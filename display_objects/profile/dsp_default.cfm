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
<cfset $.addToHTMLHeadQueue("listImageStyles.cfm")>

<cfoutput>
	<cfswitch expression="#local.contentBean.getType()#">
		<cfcase value="Portal">
			<cfif local.editable>
			<p class="profileAddableControl"><a href="./?profile.mode=inlineadd" class="button">Add</a></p>
			</cfif>
			#$.dspObject_Include(thefile='dsp_portal.cfm')#
		</cfcase>
		<cfcase value="File">
			<cfif local.editable>
			<p class="profileAddableControl"><a href="./?profile.mode=inlineedit" class="button">Edit</a></p>
			</cfif>
			<div id="svAssetDetail" class="file">
				#local.contentBean.getSummary()#
				<dl>
					<dt>URL</dt>
					<dd>https://#$.siteConfig('domain')##local.contentBean.getURL(showMeta=2)#</dd>
				</dl>
				
				<a href="https://#$.siteConfig('domain')##local.contentBean.getURL(showMeta=2)#" title="#HTMLEditFormat(local.contentBean.getMenuTitle())#" id="svAsset" class="#lcase(local.contentBean.getFileExt())#">Download File</a>
			</div>
		</cfcase>
		<cfcase value="Page">
			<cfif local.editable>
			<p class="profileAddableControl"><a href="./?profile.mode=inlineedit" class="button">Edit</a></p>
			</cfif>
			#local.contentBean.getBody()#
		</cfcase>
	</cfswitch>
</cfoutput>