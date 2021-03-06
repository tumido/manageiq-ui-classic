class TreeBuilderNetwork < TreeBuilder
  has_kids_for Lan, [:x_get_tree_lan_kids]
  has_kids_for Switch, [:x_get_tree_switch_kids]

  def override(node, object)
    unless object.kind_of?(::VmOrTemplate)
      node[:selectable] = false
      node[:class] = append_no_cursor(node[:class])
    end
  end

  def initialize(name, sandbox, build = true, **params)
    @root = params[:root]
    super(name, sandbox, build)
  end

  private

  def tree_init_options
    {:full_ids => true, :lazy => true, :onclick => "miqOnClickHostNet"}
  end

  def root_options
    {
      :text       => @root.name,
      :tooltip    => _("Host: %{name}") % {:name => @root.name},
      :icon       => 'pficon pficon-container-node',
      :selectable => false
    }
  end

  def x_get_tree_roots
    @root.switches.empty? ? [] : count_only_or_objects(false, @root.switches)
  end

  def x_get_tree_switch_kids(parent, count_only)
    objects = []
    objects.concat(parent.guest_devices) unless parent.guest_devices.empty?
    objects.concat(parent.lans) unless parent.lans.empty?
    count_only_or_objects(count_only, objects)
  end

  def x_get_tree_lan_kids(parent, count_only)
    kids = count_only ? 0 : []
    if parent.respond_to?("vms_and_templates") && parent.vms_and_templates.present?
      kids = count_only_or_objects(count_only, parent.vms_and_templates, "name")
    end
    kids
  end
end
