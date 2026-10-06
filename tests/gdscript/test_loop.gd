extends AutoworkTest

const Rules = preload("res://scripts/rules.gd")

func test_class_pools() -> void:
	var rules = Rules.new()
	assert_eq(rules.pool_for("runner"), 80, "runner")
	assert_eq(rules.pool_for("anchor"), 120, "anchor")

func test_client_rejected() -> void:
	var rules = Rules.new()
	assert_eq(rules.apply_hit("client", "runner", 5), "rejected", "client write")
	assert_eq(rules.pool_for("runner"), 80, "unchanged")
	assert_eq(rules.apply_hit("host", "runner", 5), "applied", "host write")
	assert_eq(rules.pool_for("runner"), 75, "reduced")

func test_roster_gate() -> void:
	var rules = Rules.new()
	assert_false(rules.take_roster("spectator"), "unknown")
	assert_false(rules.raid_ready(), "not picked")
	assert_true(rules.take_roster("runner"), "runner")
	assert_true(rules.raid_ready(), "ready")
	assert_eq(rules.apply_hit("client", "anchor", 5), "rejected", "client hit")
	assert_true(load("res://scenes/roster.tscn") != null, "roster loads")

func test_revive() -> void:
	var rules = Rules.new()
	assert_eq(rules.revive("runner"), "skipped", "still up")
	rules.class_pools["runner"] = 0
	assert_eq(rules.revive("runner"), "revived", "downed body")
	rules.class_pools["runner"] = 0
	rules.class_pools["anchor"] = 0
	assert_eq(rules.revive("runner"), "rejected", "both empty")
	assert_eq(rules.apply_hit("host", "runner", 5), "applied", "host hit")
