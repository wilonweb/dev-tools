

gh repo list wilonweb --source --json name,isTemplate,visibility -q '.[] | select(.isTemplate==true) | "\(.visibility | ascii_upcase) - \(.name)"'