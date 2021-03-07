defmodule ConnectionComponent do
  use Phoenix.LiveComponent
  import ProfilePlace.Util, only: [component: 2]

  def render(assigns) do
    ~L"""
      <div class="social-card bg-<%= @type %> flex flex-row">
        <div>
          <%= component "icon", icon: @type %>

          <div class="flex flex-col">
            <span class="text-sm text-white">
              <%= @name %>
            </span>

          <span class="text-sm font-medium text-white">
            <%= @desc %>
           </span>
         </div>
        </div>
      </div>
    """
  end
end
