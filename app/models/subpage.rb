class Subpage < ActiveRecord::Base
	include ActionView::Helpers::SanitizeHelper
	has_one :meta_tag, :as => :content
	before_save :update_url_name, :update_header

  def page_order_last?
    self.page_order+1 == Subpage.count
  end
	
	def update_url_name
		self.url_name = UnicodeNormalizer.normalize self.name
	end	
	
	def update_header
		self.header = self.name if self.header.to_s == ''
	end
	
	alias_method :old_meta_tag, :meta_tag

	def meta_tag
		old_meta_tag || default_meta_tag
	end	
	
	def default_meta_tag
		MetaTag.new(:title => "#{self.name}", :description => "#{self.get_default_meta_tag_description}", :keywords => "#{self.name}", :content_type => self.class.base_class.to_s, :content_id => self.id)
	end
	
	def get_default_meta_tag_description
		strip_tags(self.description.to_s)[/[A-Z|0-9].+?(\.|\!|\?)/]
	end
end
