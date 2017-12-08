class Message
  include Mongoid::Document
  include Mongoid::Timestamps
 

  belongs_to :sender, class_name: "Conversation"

  embedded_in :conversation

  field :body
  field :read_at, type: DateTime

  #validates :body, presence: true, length: { maximum: 1000 }
  #validates :sender, presence: true

  scope :unread,  ->{ where(read_at: nil) }# where(read_at: nil)

  def unread?
    read_at.nil?
  end
end
