# spec/models/manager_spec.rb
require 'rails_helper'

RSpec.describe Manager, type: :model do
  let(:manager) { Manager.new }


  before do


    manager.password = "1111"
    manager.password_confirmation = "1111"
    manager.created_at = Date.current
    manager.updated_at = Date.current
  end

  it "is valid with valid attributes" do
    manager.name = "John Doe"
    manager.email = "john.doe@example.com"
    manager.phone = "1234567890"

    expect(manager).to be_valid
  end

  it "is not valid without a name" do
    manager.name = nil
    manager.email = "john.doe@example.com"
    manager.phone = "1234567890"

    expect(manager).not_to be_valid
    expect(manager.errors[:name]).to include("can't be blank")
  end

  it "is not valid without a valid email" do
    manager.name = "John Doe"
    manager.email = "not valid"
    manager.phone = "1234567890"

    expect(manager).not_to be_valid
    expect(manager.errors[:email]).to include("Enter vaid email.")
  end

  it "is not valid without an integer phone number" do
    manager.name = "John Doe"
    manager.email = "john.doe@example.com"
    manager.phone = "123abc"

    expect(manager).not_to be_valid
    expect(manager.errors[:phone]).to include("is not a number")
  end

  it "has many employees" do
    association = described_class.reflect_on_association(:employees)
    expect(association.macro).to eq(:has_many)
  end
end
