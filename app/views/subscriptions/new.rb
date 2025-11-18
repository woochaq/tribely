# frozen_string_literal: true

class Views::Subscriptions::New < Views::Base
  include SimpleForm::ActionViewExtensions::FormHelper
  include Phlex::Rails::Helpers::FormFor
  include Phlex::Rails::Helpers::DOMClass

  def initialize(email_subscription:)
    @email_subscription = email_subscription
  end

  def page_title
    "Tribely - Subscription"
  end

  def view_template
    div(class: "flex items-center justify-center bg-base") do
      div(class: "w-full max-w-md") do
        div(class: "mx-auto bg-mantle p-8 rounded-2xl border border-crust shadow-lg") do
          h1(class: "text-3xl font-bold text-center text-text mb-4") { "Our project is launching soon!" }

          if view_context.flash[:notice].present?
            p(class: "text-center text-subtext0 mb-6") { view_context.flash[:notice] }
          else
            p(class: "text-center text-subtext0 mb-6") { "Be the first to know when we launch. Leave your email below to get notified. No marketing spam, just a single email when we go live." }
            if view_context.flash[:alert].present?
              p(class: "text-center text-maroon mb-6 bg-surface0 border border-maroon/30 rounded-md py-3 px-4 italic") do
                span(class: "mr-2") { "✋" }
                plain view_context.flash[:alert]
              end
            end
            simple_form_for(@email_subscription, url: subscriptions_path) do |f|
              f.input :email,
                autofocus: true,
                placeholder: "your@example.com",
                input_html: { class: "w-full" }

              div(class: "flex items-center justify-end gap-4 pt-4 border-t border-crust mt-6") do
                f.button :submit, "Notify me!", class: "btn-primary w-full"
              end
            end
          end
        end
      end
    end
  end
end
