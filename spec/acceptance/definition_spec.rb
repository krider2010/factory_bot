describe "an instance generated by a factory with a custom class name" do
  before do
    define_model("User", admin: :boolean)

    FactoryBot.define do
      factory :user

      factory :admin, class: User do
        admin { true }
      end
    end
  end

  subject { FactoryBot.create(:admin) }

  it { should be_kind_of(User) }
  it { should be_admin }
end

describe "attributes defined using Symbol#to_proc" do
  before do
    define_model("User", password: :string, password_confirmation: :string)

    FactoryBot.define do
      factory :user do
        password { "foo" }
        password_confirmation &:password
      end
    end
  end

  it "assigns values correctly" do
    user = FactoryBot.build(:user)

    expect(user.password).to eq "foo"
    expect(user.password_confirmation).to eq "foo"
  end

  it "assigns value with override correctly" do
    user = FactoryBot.build(:user, password: "bar")

    expect(user.password).to eq "bar"
    expect(user.password_confirmation).to eq "bar"
  end

  it "assigns overridden value correctly" do
    user = FactoryBot.build(:user, password_confirmation: "bar")

    expect(user.password).to eq "foo"
    expect(user.password_confirmation).to eq "bar"
  end
end
