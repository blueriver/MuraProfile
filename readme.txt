A simple proof of concept plugin that adds public profiles to Mura CMS. Users get public profile pages that can be editing on the frontend.

Profiles are created underneath a top level "Profiles" Portal based on the user's username:
http://domain.com/index.cfm/profiles/{username}/

The plugin also uses onSite404 to allow for uer profiles to accessible as top level architecture.
http://domain.com/index.cfm/{username}/

And with mod-rewrite can easily be changed to:
http://domain.com/{username}/