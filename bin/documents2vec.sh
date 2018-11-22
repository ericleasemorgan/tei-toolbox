#!/usr/bin/env bash

# documents2vec.sh - a front-end to documents2vec.py

# Eric Lease Morgan <eric_morgan@infomotions.com>
# October 17, 2018 - first documentation; written on a plane from Madrid to Chicago; brain-dead


# configure
INDEX='./bin/index.py'

# initialize
$INDEX new    ./corpus/cooper-last-1826.txt

# update
$INDEX update ./corpus/cooper-pioneers-1823.txt
$INDEX update ./corpus/emerson-american-227.txt
$INDEX update ./corpus/emerson-conservative-229.txt
$INDEX update ./corpus/emerson-lecture-233.txt
$INDEX update ./corpus/emerson-representative-201.txt
$INDEX update ./corpus/emerson-transcendentalist-239.txt
$INDEX update ./corpus/emerson-young-241.txt
$INDEX update ./corpus/hawthorne-artist-458.txt
$INDEX update ./corpus/hawthorne-great-466.txt
$INDEX update ./corpus/hawthorne-scarlet-63.txt
$INDEX update ./corpus/longfellow-hiawatha-1855.txt
$INDEX update ./corpus/longfellow-paul-210.txt
$INDEX update ./corpus/longfellow-village-211.txt
$INDEX update ./corpus/melville-benito-104.txt
$INDEX update ./corpus/melville-billy-105.txt
$INDEX update ./corpus/melville-typee-107.txt
$INDEX update ./corpus/thoreau-civil-182.txt
$INDEX update ./corpus/thoreau-life-183.txt
$INDEX update ./corpus/thoreau-plea-184.txt
$INDEX update ./corpus/thoreau-slavery-185.txt
$INDEX update ./corpus/thoreau-walden-186.txt
$INDEX update ./corpus/twain-30-44.txt
$INDEX update ./corpus/twain-adventures-27.txt
$INDEX update ./corpus/twain-adventures-28.txt
$INDEX update ./corpus/twain-extracts-32.txt
$INDEX update ./corpus/twain-ghost-727.txt
$INDEX update ./corpus/twain-great-34.txt
$INDEX update ./corpus/twain-my-35.txt
$INDEX update ./corpus/twain-new-36.txt
$INDEX update ./corpus/twain-niagara-37.txt
$INDEX update ./corpus/twain-political-38.txt
$INDEX update ./corpus/twain-prince-30.txt
$INDEX update ./corpus/twain-puddnhead-29.txt
$INDEX update ./corpus/twain-tom-40.txt
$INDEX update ./corpus/twain-tramp-41.txt
$INDEX update ./corpus/twain-what-42.txt

# finish & done
$INDEX finish ./foobar
exit


