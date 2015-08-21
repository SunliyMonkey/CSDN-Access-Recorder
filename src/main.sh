#!/bin/bash

source tool.sh

user=sunliymonkey
#user=hazir

blog_URL="http://blog.csdn.net/$user/article/list/"

tmp_html=.tmp_html


curl_html $blog_URL $tmp_html
echo $?
[[ $? == 1 ]] && echo "error: curl_html" && exit 1

blog_info=(`get_blog_info $tmp_html`)

[[ $? == 1 ]] && echo "error: blog_info" && exit 1

article_num=${blog_info[0]}
page_num=${blog_info[1]}

echo article_num=$article_num  page_num=$page_num


remaining=$article_num

data_file=`date  +"%Y-%m-%d-%H"`.data
rm -f $data_file

echo $data_file

for (( page=1; page <= $page_num; page++))
do
	url=$blog_URL$page
	echo $url	
	curl_html $url $tmp_html

	article_list=(`get_article_list $tmp_html`)
  	 article_ids=(`get_article_ids  $tmp_html`)
  	  click_nums=(`get_click_nums   $tmp_html`)
	comment_nums=(`get_comment_nums $tmp_html`)
		
	count=${#article_list[@]}
	((remaining=$remaining - $count))

#	echo ${article_list[@]}
#	echo ${article_ids[@]}
#	echo ${click_nums[@]}
#	echo ${comment_nums[@]}



	for (( i = 0; i < $count; i++ ))
	do
		article=${article_list[$i]}
		article_id=${article_ids[$i]}
		click_num=${click_nums[$i]}
		comment_num=${comment_nums[$i]}

		echo "$i: $article_id $article $click_num $comment_num"
		echo "$article_id $article $click_num $comment_num" >> $data_file
	done

done

echo remaining=$remaining






exit 0
