# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|	
	Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  regexp = "(?m)" + e1 + ".*<td>" + e2
  regexp = Regexp.new(regexp)

  if page.body.respond_to? :should
    page.body.should =~ regexp
  else
    assert regexp.match(page.body)
  end

  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

Then /^I should see all of the movies$/ do
	rows = Movie.count
	assert rows == all('#movies tbody tr').count
end


When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.split(", ").each do |rating|
    if uncheck then uncheck("ratings_"+rating); else check("ratings_"+rating); end
  end	
# HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
end

Then /^the director of "([^"]*)" should be "([^"]*)"$/ do |title, director|
  assert Movie.find_by_title(title).director == director
end

