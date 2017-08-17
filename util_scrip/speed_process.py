#coding=utf-8
from __future__ import division
import sys,time

def decorator(num):
    def wrapp(fn):
        def test(*args, **kw):
            fn()
            sys.stdout.write(' ' * 10 + '\r')
            sys.stdout.write(fn.__name__+"finished\n")
            sys.stdout.flush()
            sys.stdout.write(' ' * 10 + '\r')
            sys.stdout.flush()
            if num == 10:
                sys.stdout.write(str((num/10)*100)+"%"+'#'*num+'\n')
            else:
                sys.stdout.write(str((num/10)*100)+"%"+'#'*num)
            sys.stdout.flush()
        return test
    return wrapp


@decorator(1)
def task1():
    time.sleep(3)


@decorator(2)
def task2():
    time.sleep(3)

@decorator(10)
def task10():
    time.sleep(3)


task1()
task2()
task10()
