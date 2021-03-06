class TeamUserNode < Node
  belongs_to :node_object, class_name: 'TeamsUser'
  attr_accessible

  def self.table
    "teams_users"
  end

  def get_name
    TeamsUser.find(self.node_object_id).name
  end

  def self.get(parent_id)
    nodes = Node.joins("INNER JOIN teams_users ON nodes.node_object_id = teams_users.id")
                .select('nodes.*')
                .where("nodes.type = 'TeamUserNode'")
    nodes.where("teams_users.team_id = ?", parent_id) if parent_id
  end

  def is_leaf
    true
  end
end
