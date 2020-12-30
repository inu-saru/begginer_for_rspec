require 'rails_helper'

RSpec.describe User, type: :model do
  it 'first_name, first_name, emailがある場合、有効な状態であること'

  it 'first_nameがない場合、無効な状態であること'

  it 'last_nameがない場合、無効な状態であること'

  it 'emailが重複する場合、無効な状態であること'
end
