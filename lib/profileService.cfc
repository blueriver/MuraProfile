<!---
   Copyright 2011 Blue River Interactive

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
--->
<cfcomponent extends="mura.cfobject" output="false">

<cffunction name="init" access="public" returntype="any" output="false">

	<cfset variables.configBean = getBean('configBean')>
	<cfset variables.contentManager = getBean('contentManager')>
	<cfset variables.fileManager = getBean('fileManager')>
		
	<cfreturn this>
</cffunction>

<cffunction name="setPluginConfig" output="false">
<cfargument name="pluginConfig">
<cfset variables.pluginConfig=arguments.pluginConfig>
</cffunction>

<cffunction name="buildRequirements"> 
<cfargument name="$"> 
 <cfset var rsSites= variables.pluginConfig.getAssignedSites()> 
 
 <cfloop query="rsSites"> 
  <cfset $.event("siteID",rsSites.siteID)> 
  <cfset buildProfileSubType($)> 
  <cfset buildPostSubType($)>
  <cfset buildProfilePortal($)>
</cfloop> 
</cffunction>

<cffunction name="buildProfileSubType"> 
<cfargument name="$"> 
 <cfset var subType=$.globalConfig("classExtensionManager").getSubTypeBean()> 
 <cfset subtype.setType("Portal")> 
 <cfset subType.setSubType("Profile")> 
 <cfset subType.setSiteID($.event('siteID'))> 
 <cfset subType.load()> 
 <cfset subType.setBaseTable("tcontent")> 
 <cfset subType.setBaseKeyField("contentHistID")> 
 <cfset subType.save()> 
</cffunction> 

<cffunction name="buildPostSubType"> 
<cfargument name="$"> 
 <cfset var subType=$.globalConfig("classExtensionManager").getSubTypeBean()> 
 <cfset subtype.setType("Page")> 
 <cfset subType.setSubType("Post")> 
 <cfset subType.setSiteID($.event('siteID'))> 
 <cfset subType.load()> 
 <cfset subType.setBaseTable("tcontent")> 
 <cfset subType.setBaseKeyField("contentHistID")> 
 <cfset subType.save()> 
</cffunction> 

<cffunction name="buildProfilePortal" output="false" returntype="void"> 
<cfargument name="$"> 
 <!--- Load the existing top level Portal name "Profiles"---> 
 <cfset var profilePortal=$.getBean('content').loadBy(filename='profiles')> 
 
 <!--- If the protal does not exists create it ---> 
 <cfif profilePortal.getIsNew()> 
  <!--- Place the profile under the "Profiles" portal---> 
  <cfset profilePortal.setParentID(profilePortal.getContentID())> 
<!--- Set the parentID to the homepage ---> 
  <cfset 
profilePortal.setParentID( $.getBean('content').loadBy(filename='').getContentID() )> 
  
  <!--- Set the profiles siteID ---> 
  <cfset profilePortal.setSiteID($.event('siteID'))> 
   
  <!--- Set the content type to Portal ---> 
  <cfset profilePortal.setType("Portal")> 
  
  <!--- Set the profiles remoteID to the current user's userID ---> 
  <cfset profilePortal.setTitle("Profiles")> 
  
  <!--- You must explicitly approve the content or it will just save as a 
draft.---> 
  <cfset profilePortal.setApproved(1)> 
  
  <!---  Save the new Profile portal ---> 
  <cfset profilePortal.save()> 
 </cfif> 
 
</cffunction> 

<cffunction name="deleteProfile" output="false" returntype="void"> 
<cfargument name="$"> 
 <cfset var user=$.event('userBean')> 
 <!--- Load the current user's profile by remoteID and delete it---> 
 <cfset $.getBean('content').loadBy(remoteID=user.getUserID()).delete()> 
</cffunction> 

<cffunction name="buildProfile" output="false" returntype="void"> 
<cfargument name="$"> 
 <!--- Load the existing top level Portal name "Profiles"---> 
 <cfset var profilePortal=$.getBean('content').loadBy(filename='profiles')> 
 <cfset var user=$.event('userBean')> 
 <cfset var profile="">

 <cfif isObject(user)>
 <!--- Load the current user's profile by remoteID ---> 
 <cfset var profile=$.getBean('content').loadBy(remoteID=user.getUserID())> 
 <!--- Place the profile under the "Profiles" portal---> 
 <cfset profile.setParentID(profilePortal.getContentID())> 
  
 <!--- Set the profiles siteID ---> 
 <cfset profile.setSiteID(profilePortal.getSiteID())> 
  
 <!--- Set the profiles remoteID to the current user's userID ---> 
 <cfset profile.setRemoteID(user.getUserID())> 
 
 <!--- Set the profile's content type ---> 
 <cfset profile.setType("Portal")> 
 
 <!--- Set the profile's content subtype ---> 
 <cfset profile.setSubType("Profile")> 
 
 <!--- The "Title" attribute is the long title that appears in the default <h2> 
tag ---> 
 <cfset profile.setTitle(user.getUsername())> 
<!--- The "MenuTitle" attribute is the shorter title that appears in site 
navigation ---> 
 <cfset profile.setMenuTitle(user.getUsername())> 
  
 <!--- The "HTMLTitle" attribute is the title that appears in the default <title> 
tag ---> 
 <cfset profile.setHTMLTitle(user.getUsername())> 
 
 <!--- The "URLTitle" attribute is what is used in creating the filename 
attribute ---> 
 <cfset profile.setURLTitle(user.getUsername())> 
  
 <!--- You must explicitly approve the content or it will just be saved as a 
draft ---> 
 <cfset profile.setApproved(1)> 
 
 <!--- Save the profile.  If it already existed it will be updated ---> 
 <cfset profile.save()> 
  
 <!--- Since every time a use logs in the page is updated, clear version history 
---> 
 <cfset profile.deleteVersionHistory()> 
 </cfif>
</cffunction> 

<cffunction name="lookUpProfile" output="false" returntype="void"> 
<cfargument name="$"> 
 <!--- Load a content bean by the pre-pending the currentFilename with 
'profiles/' ---> 
 <cfset var profileCheck=$.getBean('content').loadBy(filename='profiles/' & 
$.event('currentFilename'))> 
 
 <!--- If it's not new then it found a profile, so set the current request 
contenBean to the found profile bean---> 
 <cfif not profileCheck.getIsNew()> 
  <cfset $.event('contentBean',profileCheck)> 
 </cfif> 
</cffunction> 

<cffunction name="getCurrentProfile" output="false"> 
<cfargument name="$"> 
	<cfset var crumbData=$.event("crumbData")>
	<cfreturn $.getBean("content").loadBy(contentID=crumbData[arrayLen(crumbData)-2].contentID)>
</cffunction>

<cffunction name="savePost" access="public" returntype="any" output="false">
		<cfargument name="$">
		<cfset var contentBean = getBean("content").loadBy(contentID=$.event('contentID'), siteID=$.event('siteID'))>
		
		<cfset contentBean.setTitle($.event('title'))>
		<cfset contentBean.setMenuTitle($.event('title'))>
		<cfset contentBean.setHTMLTitle($.event('title'))>
		<cfset contentBean.setURLTitle($.event('title'))>
		<cfset contentBean.setBody($.event('body'))>
		<cfset contentBean.setTags($.event('tags'))>
		<cfset contentBean.setParentID($.event('parentID'))>
		<cfset contentBean.setType($.event('type'))>
		<cfset contentBean.setSubType($.event('subType'))>
		<cfset contentBean.setRemoteSource($.event('remoteSource'))>
		<cfset contentBean.setCredits($.event('credits'))>
		<cfset contentBean.setDisplay(1)>
		<cfset contentBean.setApproved(1)>
		<cfset contentBean.save()>
		
		<cfreturn contentBean>
	</cffunction>
	
<cffunction name="deletePost" access="public" returntype="any" output="false">
	<cfargument name="$">
	<cfset var contentBean = getBean("content").loadBy(contentID=$.content('contentID'), siteID=$.event('siteID'))>
	<cfset contentBean.delete()>
</cffunction>
	
</cfcomponent>