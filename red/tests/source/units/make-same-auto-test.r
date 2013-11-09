REBOL [
	Title:   "Generates Red equal? tests"
	Author:  "Peter W A Wood"
	File: 	 %make-same-auto-test.r
	Version: 0.1.0
	Tabs:	 4
	Rights:  "Copyright (C) 2013 Peter W A Wood. All rights reserved."
	License: "BSD-3 - https://github.com/dockimbel/Red/blob/origin/BSD-3-License.txt"
]

;; initialisations 

make-dir %auto-tests/
infix-file: %auto-tests/infix-same-auto-test.red
prefix-file: %auto-tests/same-auto-test.red

test-src: {
Red [
	Title:   "Red infix or prefix equal test script"
	Author:  "Nenad Rakocevic & Peter W A Wood"
	File: 	 ***FILE***
	Tabs:	 4
	Rights:  "Copyright (C) 2011-2013 Nenad Rakocevic & Peter W A Wood. All rights reserved."
	License: "BSD-3 - https://github.com/dockimbel/Red/blob/origin/BSD-3-License.txt"
]

comment {  This file is generated by make-equal-auto-test.r
  Do not edit this file directly.
}

;make-length:***MAKELENGTH***           

#include  %../../../../../quick-test/quick-test.red
}

;;functions

group-title: ""                         ;; title of current group
group-test-no: 0                        ;; number of current test in group

add-same-test: func [
  expected [string!]
  actual   [string!]
][
  add-test
  append infix-src join {--assert } [expected " == " actual newline]
  append prefix-src join {--assert same? } [expected " " actual newline]
]

add-not-same-test: func [
  expected [string!]
  actual   [string!]
][
  add-test
  append infix-src join {--assert not } [expected " == " actual newline]
  append prefix-src join {--assert not same? } [expected " " actual newline]
]

add-test: func [] [
  group-test-no: group-test-no + 1
  append infix-src join {--test-- "infix-same-} 
    [group-title "-" group-test-no {"} newline]
  append prefix-src join {--test-- "prefix-same-} 
    [group-title "-" group-test-no {"} newline]
]

add-test-with-code: func [
  code        [string!]
  assertion   [string!]
][
  add-test
  append infix-src join code newline
  append prefix-src join code newline
  append infix-src join {--assert } [assertion newline]
  append prefix-src join {--assert } [assertion newline]
]
  
add-test-text: func [
  text  [string!]
][
  append infix-src join replace copy text "***FIX***" "infix" newline
  append prefix-src join replace copy text "***FIX***" "prefix" newline
]

start-group: func [
  title [string!]
][
  group-title: title
  group-test-no: 0
  add-test-text join {===start-group=== "} [title {"}]
]
  

;; processing 
replace test-src {***MAKELENGTH***} length? read %make-equal-auto-test.r
infix-src: copy test-src
replace infix-src {***FILE***} :infix-file
prefix-src: copy test-src
replace prefix-src {***FILE***} :prefix-file

add-test-text {~~~start-file~~~ "***FIX***-same"}

start-group "same-datatype"
add-same-test "0" "0"
add-same-test "1" "1"
add-same-test "FFFFFFFFh" "-1"
add-same-test "[]" "[]"
add-same-test "[a]" "[a]"
add-same-test "[A]" "[a]"
add-same-test "['a]" "[a]"
add-same-test "[a:]" "[a]"
add-same-test "[:a]" "[a]"
add-same-test "[:a]" "[a:]"
add-same-test "[abcde]" "[abcde]"
add-same-test "[a b c d]" "[a b c d]"
add-same-test "[b c d]" "next [a b c d]"
add-same-test "[b c d]" "(next [a b c d])"
add-same-test {"a"} {"a"}
add-same-test {"a"} {"A"}
add-same-test {"abcdeè"} {"abcdeè"}
add-same-test {(next "abcdeè")} {next "abcdeè"}
add-same-test {(first "abcdeè")} {first "abcdeè"}
add-same-test {(last "abcdeè")} {last "abcdeè"}
add-same-test {"abcde^^(2710)é^^(010000)"} {"abcde^^(2710)é^^(010000)"} 
;; need to escape the ^ as file is processed by REBOL
add-same-test {[d]} {back tail [a b c d]}
add-same-test {"2345"} {next "12345"}
add-same-test {#"z"} {#"z"}
add-not-same-test {#"z"} {#"Z"}
add-not-same-test {#"e"} {#"è"}
add-same-test {#"^^(010000)"} {#"^^(010000)"}
add-same-test {true} {true}
add-same-test {false} {false}
add-not-same-test {false} {true}
add-not-same-test {true} {false}
add-same-test {none} {none}
add-same-test {'a} {'a}
add-same-test {'a} {'A}
add-same-test {(first [a])} {first [a]}
add-same-test {'a} {first [A]}
add-same-test {'a} {first ['a]}
add-same-test {'a} {first [:a]}
add-same-test {'a} {first [a:]}
add-same-test {(first [a:])} {first [a:]}
add-same-test {(first [:a])} {first [:a]}
add-same-test {[a b c d e]} {first [[a b c d e]]}
add-test-with-code {ea-result: 1 == 1} {ea-result = true}
add-test-with-code {ea-result: 1 == 0} {ea-result = false}
add-test-with-code {ea-result: same? 1 1} {ea-result = true}
add-test-with-code {ea-result: same? 1 0} {ea-result = false}
add-test-text {===end-group===}

start-group {implcit-cast}
add-not-same-test {#"0"} {48}
add-not-same-test {48} {#"0"}
add-not-same-test {#"^^(2710)"} {10000}
add-not-same-test {#"^^(010000)"} {65536}
add-test-with-code {ea-result: #"1" == 49} {ea-result = false}
add-test-with-code {ea-result: same? #"^^(010000)" 10000} {ea-result = false}
add-test-text {===end-group===}

add-test-text {~~~end-file~~~}

write infix-file infix-src
write prefix-file prefix-src

print "Same auto test files generated"

