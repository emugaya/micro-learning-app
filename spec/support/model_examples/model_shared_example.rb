# model_shared_example.rb

RSpec.shared_examples 'an invalid object' do |test_values|
    it 'validates input when invalid ' do
      expect(FactoryBot.build(test_values)).to be_invalid
    end
end

RSpec.shared_examples 'a valid object' do |test_values|
    it "succeeds when input is valid" do
      expect(FactoryBot.build(test_values)).to be_valid
    end
end

RSpec.shared_examples 'retrieving items' do |model_name, model, related_child_model|
  it "returns #{related_child_model} belonging to a #{model_name}" do
    model_name = model.find(1)

    if related_child_model == 'lessons'
      # Course Model
      expect(model_name.lessons.length).to be(1)
    elsif related_child_model == 'courses'
      # Category Model
      expect(model_name.courses.length).to be(1)
    else related_child_model == 'enrollments'
      # User model
      expect(model_name.enrollments.length).to be(1)
    end
  end
end

