class Components::Shared::Form::Switch < Components::Base
  attr_reader :form, :field, :label_text

  def initialize(form:, field:, label: nil)
    @form = form
    @field = field
    @label_text = label || field.to_s.humanize
  end

  def view_template
    label(class: "relative inline-flex items-center cursor-pointer") do
      form.check_box(field, class: "sr-only peer")
      div(class: "w-11 h-6 bg-surface1 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-primary/20 rounded-full peer peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:start-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-primary")
      span(class: "ms-3 text-sm font-medium text-text") { label_text }
    end
  end
end
