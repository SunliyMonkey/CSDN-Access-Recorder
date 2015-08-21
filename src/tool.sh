#!/bin/bash


flag_link_title='<span class="link_title">'

#echo $flag_link_title



#input : @url @file 
#output: error
function curl_html(){
	url=$1
	file=$2
	rm -f $file
	curl -# $url | sed 's///g' > $file
	echo #?
}

#return @article_num, @max_page_num
function get_blog_info(){
	html=$1

	match_str=`cat $html | grep -oE "<span> [0-9]*条数据 *共[0-9]*页"`
    err=$?

	[[ $err == 1 ]] && echo `cat $html | grep  "$flag_link_title" | wc -l` && echo 1 && exit 0 

	result=`echo $match_str | grep -oE "[0-9]*"`
    result_num=`echo $match_str | grep -oE "[0-9]*" | wc -l`  

    [[ $result_num != 2 ]] && exit 1		

	echo $result
	exit 0
}

#echo `get_blog_info 1`
#echo `get_blog_info 2`
#echo `get_blog_info 3`
#echo `get_blog_info 4`


function get_article_ids(){
	html=$1	
	ret=`cat $html | grep -E "$flag_link_title" | grep -oE "[0-9]*"`
	echo $ret
	
}

function get_click_nums(){

	html=$1	
	ret=`cat $html | grep -oE "阅读</a>\([0-9]*\)" | grep -oE "[0-9]*"`
	echo $ret

}


function get_comment_nums(){

	html=$1	
	ret=`cat $html | grep -oE "评论</a>\([0-9]*\)" | grep -oE "[0-9]*"`
	echo $ret

}

function get_article_list(){
	
	html=$1

	# replace space to '_' 
	ret=`cat $html | grep -A 1 -E "$flag_link_title" | sed -n  "2~3p" | sed "s/^[\t ]*//g ; s/[\t ]*$//g; s/[\t ]/_/g" `

	echo $ret
}


#echo `get_article_list .tmp_html`

