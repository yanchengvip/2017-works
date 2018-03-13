class Auction::Brand < ApplicationRecord

  INITIAL = 'A'..'Z'
  RECOMMEND = {'featured' => '精选', 'newest' => '最新', 'hot' => '热门'}
  # blongs_to :editor
end
