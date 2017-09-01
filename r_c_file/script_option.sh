#! /bin/bash


re_str="^-.*"
arg_status=0

###################################################################

usage()
{
    cat << EOF
    Usage:
        $(basename $0) -q <query keyword>        Query Keyword about Host computer or docker info; 
    Example:
        $(basename $0) -q 10.1.7.32
        or
        $(basename $0) -q docker010001040185
EOF
    exit 1
}

####################################################################

#匹配输入参数不为“-”开头的
[[ $1 =~ ${re_str} ]] && arg_status=1
# 参数为空  或者  用户瞎jb输入的 eg：wahaha  这两种情况直接提示
[ $# -eq 0 ] || [[ ${arg_status} -eq 0 ]] && usage
#这里错误输出到黑洞中，因为有的时候参数可能输入-z 回报无效参数的错误
while getopts hq:a OPTION 2>/dev/null
do
    case $OPTION in
	h) usage ;;
        q) echo "arg=${OPTARG} index=${OPTIND}";;
        *) usage ;; 
    esac
done


