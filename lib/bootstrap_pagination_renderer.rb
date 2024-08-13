require 'will_paginate/view_helpers/action_view'

class BootstrapPaginationRenderer < WillPaginate::ActionView::LinkRenderer
  def container_attributes
    { class: 'pagination' }
  end

  def page_number(page)
    if page == current_page
      tag(:li, tag(:span, page), class: 'page-item active')
    else
      tag(:li, link(page, page, rel: rel_value(page)), class: 'page-item')
    end
  end

  def previous_or_next_page(page, text, classname)
    if page
      tag(:li, link(text, page), class: 'page-item')
    else
      tag(:li, tag(:span, text), class: 'page-item disabled')
    end
  end

  def html_container(html)
    tag(:nav, tag(:ul, html, container_attributes))
  end

  private

  def link(text, target, attributes = {})
    # attributes['data-remote'] = true
    super
  end
end