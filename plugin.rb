# frozen_string_literal: true

# name: x-discourse-data-explorer-max
# about: Plugin to override the data explorer plugin max settings
# version: 0.1.0
# authors: Thomas K. Running
# url: https://github.com/tkrunning/x-discourse-data-explorer-max

enabled_site_setting :data_explorer_max_enabled

# Data Explorer is bundled with core and caps results at a hardcoded
# DiscourseDataExplorer::QUERY_RESULT_MAX_LIMIT. Plugins load alphabetically,
# so the "x-" prefix makes this run after it: config/settings.yml redefines
# data_explorer_query_result_limit with a higher max, and this raises the cap.
after_initialize do
  if defined?(::DiscourseDataExplorer::QUERY_RESULT_MAX_LIMIT)
    ::DiscourseDataExplorer.send(:remove_const, :QUERY_RESULT_MAX_LIMIT)
    ::DiscourseDataExplorer.const_set(:QUERY_RESULT_MAX_LIMIT, 1_000_000_000)
  end

  # Core marks the limit setting as hidden; keep it editable in the admin UI.
  register_modifier(:hidden_site_settings) do |hidden|
    hidden - [:data_explorer_query_result_limit]
  end
end
