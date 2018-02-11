Documentation for Warmup Assignment 2
=====================================

+-------+
| BUILD |
+-------+

Comments: type make under the folder of files

+---------+
| GRADING |
+---------+

Basic running of the code : 100 out of 100 pts

Missing required section(s) in README file : No
Cannot compile : Can Compile
Compiler warnings : No
"make clean" : Cleaned, remove all file
Segmentation faults : No
Separate compilation : Yes
Using busy-wait : No
Handling of commandline arguments:
    1) -n : Yes
    2) -lambda : Yes
    3) -mu : Yes
    4) -r : Yes
    5) -B : Yes
    6) -P : Yes
Trace output :
    1) regular packets: Yes
    2) dropped packets: Yes
    3) removed packets: Yes
    4) token arrival (dropped or not dropped): Yes
Statistics output :
    1) inter-arrival time : Yes
    2) service time : Yes
    3) number of customers in Q1 : Yes
    4) number of customers in Q2 : Yes
    5) number of customers at a server : Yes
    6) time in system : Yes
    7) standard deviation for time in system : Yes
    8) drop probability : Yes
Output bad format : No
Output wrong precision for statistics (should be 6-8 significant digits) : No
Large service time test : Passed
Large inter-arrival time test : Passed
Tiny inter-arrival time test : Passed
Tiny service time test : Passed
Large total number of customers test : Passed
Large total number of customers with high arrival rate test : Passed
Dropped tokens test : Passed
Cannot handle <Cntrl+C> at all (ignored or no statistics) : Can Handle
Can handle <Cntrl+C> but statistics way off : Not way off
Not using condition variables and do some kind of busy-wait : Mp
Synchronization check : Use one Mutex
Deadlocks : No

+----------------------+
| BUGS / TESTS TO SKIP |
+----------------------+

Is there are any tests in the standard test suite that you know that it's not
working and you don't want the grader to run it at all so you won't get extra
deductions, please list them here.  (Of course, if the grader won't run these
tests, you will not get plus points for them.)

Comments: No before submit

+------------------+
| OTHER (Optional) |
+------------------+

Comments on design decisions: Follow the instruction
Comments on deviation from spec: None

