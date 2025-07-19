from bs4 import BeautifulSoup

# Open the HTML file and read its content into a string variable
with open('target.html', 'r') as file:
    html_content = file.read()

# Create a BeautifulSoup object to parse the HTML content
soup = BeautifulSoup(html_content, 'html.parser')

# Find all the tags that need pruning (e.g., div, span)
tags_to_prune = ['div', 'span']

# Iterate over the specified tags and prune them
for tag in soup.find_all():
    # Preserve navigation-related attributes (e.g., class, id)


    # Remove the tag's content while preserving the structure
    # Remove unwanted attributes while preserving desired ones
    attributes_to_remove = [attr for attr in tag.attrs if attr not in ['class', 'id']]
    for attr in attributes_to_remove:
        del tag[attr]

# Get the pruned HTML content
pruned_html = str(soup)

# Save the pruned HTML to a new file
with open('target2.html', 'w+') as file:
    file.write(pruned_html)
