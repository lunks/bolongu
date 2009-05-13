class Tweet < ActiveRecord::Base

  include Notifiable
  include Commentable

  before_validation_on_create :tweet!
  before_validation_on_create :make_tags
  before_destroy :untweet!

  belongs_to :tweetable, :polymorphic => true
  belongs_to :account
  
  validates_presence_of :twitter_id
  validates_uniqueness_of :twitter_id
  
  attr_accessor :options
  
  def should_notify
    tweetable.nil?
  end
  
  def blog_private
    false
  end
  
  def options
    @options ||= {}
  end
  
  def tweet!
    self.twitter_id = account.twitter_client.update(body, options).id
  end
  
  def untweet!
    begin
      account.twitter_client.status_destroy(twitter_id)
    rescue Twitter::NotFound => e
    end
  end
  
  def make_tags
    string_tag_list = ''
    body.scan(/ #\w*/).each { |word| string_tag_list << "#{word[/.(.*)/m,1]}," }
    self.tag_list = string_tag_list
  end
end
