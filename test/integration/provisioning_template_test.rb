require 'test_helper'

class ProvisioningTemplateIntegrationTest < ActionDispatch::IntegrationTest
  test "index page" do
    assert_index_page(provisioning_templates_path,"Provisioning Templates","New Template")
  end

  describe 'js tests' do
    setup do
      @driver = Capybara.current_driver
      Capybara.current_driver = Capybara.javascript_driver
      login_admin
    end

    teardown do
      Capybara.current_driver = @driver
    end

    test "edit template page" do
      template = FactoryGirl.create(:provisioning_template)
      visit provisioning_templates_path
      click_link template.name
      fill_in 'provisioning_template_name', :with => 'updated template'

      click_link 'Type'
      assert has_unchecked_field?('provisioning_template_snippet')
      assert_equal template.template_kind.name, find("#s2id_provisioning_template_template_kind_id .select2-chosen").text

      # check the type dropdown is hidden when snippet is checked
      assert has_selector?('#s2id_provisioning_template_template_kind_id')
      find_field('provisioning_template_snippet').click
      assert has_no_selector?('#s2id_provisioning_template_template_kind_id')
      find_field('provisioning_template_snippet').click
      assert has_selector?('#s2id_provisioning_template_template_kind_id')

      assert_submit_button(provisioning_templates_path)
      assert page.has_link? 'updated template'
    end

    test "edit snippet page" do
      template = FactoryGirl.create(:provisioning_template, :snippet)
      visit provisioning_templates_path
      click_link template.name
      fill_in 'provisioning_template_name', :with => 'updated snippet'

      click_link 'Type'
      assert has_checked_field?('provisioning_template_snippet')

      # check the type dropdown is visible when snippet is unchecked
      assert has_no_selector?('#s2id_provisioning_template_template_kind_id')
      find_field('provisioning_template_snippet').click
      assert has_selector?('#s2id_provisioning_template_template_kind_id')
      find_field('provisioning_template_snippet').click
      assert has_no_selector?('#s2id_provisioning_template_template_kind_id')

      assert_submit_button(provisioning_templates_path)
      assert page.has_link? 'updated snippet'
    end
  end
end