#coding=utf-8
from __future__ import division
import sys,time

def decorator(num):
    def wrapp(fn):
        def test(*args, **kw):
            data = fn()
            sys.stdout.write(' ' * 100 + '\r')
            sys.stdout.flush()
            for i in data:
                print i
            if num == 10:
                sys.stdout.write(str((num/10)*100)+ '% : '+'#'*10*num+'\n')
            else:    
                sys.stdout.write(str((num/10)*100)+"% : "+'#'*10*num+'\r')
            sys.stdout.flush()
        return test
    return wrapp


@decorator(1)
def task1():
    time.sleep(3)
    return ['a','b','c']

@decorator(2)
def task2():
    time.sleep(3)
    return ['a','b','c']

@decorator(10)
def task10():
    time.sleep(3)
    return ['a','b','c']


task1()
task2()
task10()
