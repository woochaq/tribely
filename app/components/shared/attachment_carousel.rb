class Components::Shared::AttachmentCarousel < Components::Base
  include Phlex::Rails::Helpers::URLFor
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::ImageTag
  include ActionView::Helpers::NumberHelper

  def initialize(attachments:)
    @attachments = attachments
  end

  def view_template
    render RubyUI::Carousel.new(class: "w-full") do
      render RubyUI::CarouselContent.new(class: "-ml-4") do
        @attachments.each do |attachment|
          render RubyUI::CarouselItem.new(class: "pl-4 basis-1/2 sm:basis-1/3 md:basis-1/4 lg:basis-1/5 xl:basis-1/6") do
            div(class: "p-1") do
              render RubyUI::Card.new(class: "overflow-hidden border bg-surface0 border-crust text-card-foreground rounded-lg shadow-sm") do
                render RubyUI::CardContent.new(class: "flex aspect-square items-center justify-center p-0 relative") do
                  render_attachment_preview(attachment)
                end

                render RubyUI::CardFooter.new(class: "p-2 text-center border-t border-crust") do
                  div(class: "flex justify-between items-center text-xs") do
                    span(class: "text-text") { number_to_human_size(attachment.byte_size) }
                    link_to "Download", helpers.rails_blob_url(attachment, disposition: "attachment"), class: "text-primary hover:underline font-medium"
                  end
                end
              end
            end
          end
        end
      end
      render RubyUI::CarouselPrevious.new(class: "cursor-pointer bg-mauve")
      render RubyUI::CarouselNext.new(class: "cursor-pointer bg-mauve")
    end
  end

  private

  def render_attachment_preview(attachment)
    if attachment.video?
      render_video(attachment)
    elsif attachment.image? || (attachment.representable? && attachment.content_type == "application/pdf")
      render_image(attachment)
    else
      render_file_icon(attachment)
    end
  end

  def render_video(attachment)
    video(controls: true, class: "absolute inset-0 w-full h-full object-cover") do
      source(src: helpers.rails_blob_url(attachment), type: attachment.content_type)
      plain "Your browser does not support the video tag."
    end
  end

  def render_image(attachment)
    link_to(helpers.rails_blob_url(attachment), target: "_blank", rel: "noopener", class: "absolute inset-0 w-full h-full flex items-center justify-center") do
      image_tag(attachment.representation(resize_to_limit: [ 400, 400 ]), class: "object-cover w-full h-full")
    end
  end

  def render_file_icon(attachment)
    link_to(helpers.rails_blob_url(attachment), class: "flex flex-col items-center justify-center text-center p-4 w-full h-full bg-muted/40") do
      svg(
        class: "w-10 h-10 text-muted-foreground mb-2",
        fill: "none",
        stroke: "currentColor",
        viewbox: "0 0 24 24",
        xmlns: "http://www.w3.org/2000/svg"
      ) do |s|
        s.path(
          stroke_linecap: "round",
          stroke_linejoin: "round",
          stroke_width: "1.5",
          d: "M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z"
        )
      end
      span(class: "text-xs font-medium text-muted-foreground break-all") { attachment.filename.to_s }
    end
  end
end
