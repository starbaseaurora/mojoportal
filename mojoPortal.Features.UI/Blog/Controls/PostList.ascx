﻿<%@ Control Language="C#" AutoEventWireup="false" CodeBehind="PostList.ascx.cs" Inherits="mojoPortal.Web.BlogUI.PostList" %>
<%@ Register TagPrefix="blog" TagName="NavControl" Src="~/Blog/Controls/BlogNav.ascx" %>
<%@ Register Namespace="mojoPortal.Web.BlogUI" Assembly="mojoPortal.Features.UI" TagPrefix="blog" %>

<blog:BlogDisplaySettings ID="displaySettings" runat="server" />
<blog:NavControl ID="navTop" runat="server" />
<blog:BlogPostListWrapperPanel ID="divblog" runat="server" CssClass="blogcenter-rightnav">
	<asp:Repeater ID="rptBlogs" runat="server" SkinID="Blog" EnableViewState="False">
		<ItemTemplate>
			<blog:BlogPostListItemPanel ID="bi1" runat="server" CssClass="blogitem">
				<<%# itemHeadingElement %> class="blogtitle">
					<asp:HyperLink runat="server"
						SkinID="BlogTitle"
						ID="lnkTitle"
						EnableViewState="false"
						CssClass="blogitemtitle"
						Text='<%# Eval("Heading") %>'
						Visible='<%# Config.UseLinkForHeading %>'
						NavigateUrl='<%# FormatBlogTitleUrl(Eval("ItemUrl").ToString(), Convert.ToInt32(Eval("ItemID")))  %>'
					></asp:HyperLink>

					<asp:Literal ID="litTitle" runat="server" Text='<%# Eval("Heading") %>' Visible='<%#(!Config.UseLinkForHeading) %>' />

					<asp:HyperLink runat="server"
						ID="editLink"
						EnableViewState="false"
						Text="<%# EditLinkText %>"
						ToolTip="<%# EditLinkTooltip %>"
						ImageUrl='<%# EditLinkImageUrl %>'
						NavigateUrl='<%# this.SiteRoot +
							"/Blog/EditPost.aspx?pageid=" +
							PageId.ToString() +
							"&amp;ItemID=" +
							DataBinder.Eval(Container.DataItem,"ItemID") +
							"&amp;mid=" +
							ModuleId.ToString()
						%>'
						Visible='<%# CanEditPost(Convert.ToInt32(Eval("UserID"))) %>'
						CssClass="ModuleEditLink"
					/>
				</<%# itemHeadingElement %>>

				<asp:Literal ID="litSubtitle" runat="server" EnableViewState="false" Text='<%# FormatSubtitle(Eval("SubTitle").ToString()) %>' />

				<% if (!displaySettings.PostListUseBottomDate && !TitleOnly) { %>

				<div class="blogdate">
					<span class="blogauthor">
						<%# FormatPostAuthor(Convert.ToBoolean(Eval("ShowAuthorName")), Eval("Name").ToString(),Eval("FirstName").ToString(),Eval("LastName").ToString())%>
					</span>
					<span class="bdate" id="spnTopDate" runat="server" enableviewstate="false" visible='<%# !displaySettings.PostListHideDate %>'>
						<%# FormatBlogDate(Convert.ToDateTime(Eval("StartDate"))) %>
					</span>

					<asp:Repeater ID="rptTopCategories" runat="server" Visible='<%# displaySettings.ShowTagsOnPostList %>'>
						<HeaderTemplate>
							<span class="blogtags tagslabel">
								<mp:SiteLabel ID="lblcatBottom" runat="server" ConfigKey='<%# CategoriesResourceKey %>' ResourceFile="BlogResources" UseLabelTag="false" ShowWarningOnMissingKey="false" />
							</span>
							<span class="blogtags">
						</HeaderTemplate>
						<ItemTemplate>
							<asp:HyperLink runat="server"
								ID="Hyperlink6"
								EnableViewState="false"
								Text='<%# Eval("Category").ToString() %>' data-category='<%# Eval("Category").ToString() %>'
								NavigateUrl='<%# this.SiteRoot +
									"/Blog/ViewCategory.aspx?cat=" +
									DataBinder.Eval(Container.DataItem,"CategoryID") +
									"&amp;pageid=" +
									PageId.ToString() +
									"&amp;mid=" +
									ModuleId.ToString()
								%>'></asp:HyperLink>
						</ItemTemplate>
						<FooterTemplate>
							</span>
						</FooterTemplate>
					</asp:Repeater>
				</div>

				<% } %>

				<asp:Panel ID="pnlPost" runat="server" Visible='<%# !TitleOnly %>'>
					<portal:mojoRating runat="server"
						ID="Rating"
						Enabled='<%# EnableContentRating && !displaySettings.UseBottomContentRating %>'
						ContentGuid='<%# new Guid(Eval("BlogGuid").ToString()) %>'
						AllowFeedback='false' />

					<mp:OdiogoItem runat="server"
						ID="od1"
						OdiogoFeedId='<%# Config.OdiogoFeedId %>'
						ItemId='<%# DataBinder.Eval(Container.DataItem,"ItemID") %>'
						ItemTitle='<%# Eval("Heading") %>' />

					<div class="blogtext">
						<%# FormatBlogEntry(Eval("Description").ToString(), 
							Eval("Abstract").ToString(), 
							Eval("ItemUrl").ToString(), 
							Convert.ToInt32(Eval("ItemID")),
							Eval("HeadlineImageUrl").ToString(),
							Convert.ToBoolean(Eval("IncludeImageInExcerpt")),
							Eval("Heading").ToString()
						) %>
					</div>

					<asp:Repeater ID="rptAttachments" runat="server" Visible='<%# !useExcerpt && !TitleOnly %>'>
						<ItemTemplate>
							<portal:MediaElement runat="server"
								ID="ml1"
								EnableViewState="false"
								FileUrl='<%# attachmentBaseUrl + Eval("ServerFileName") %>'
								AddInitScript="true"
								IncludeDownloadLinkForMedia='<%# Convert.ToBoolean(Eval("ShowDownloadLink")) %>' />
						</ItemTemplate>
					</asp:Repeater>

					<portal:LocationMap runat="server"
						ID="gmap"
						Visible='<%# ((Eval("Location").ToString().Length > 0)&&(ShowGoogleMap &&(!Convert.ToBoolean(Eval("UseBingMap"))))) %>'
						Location='<%# Eval("Location") %>' GMapApiKey='<%# GmapApiKey %>'
						EnableMapType='<%# Convert.ToBoolean(Eval("ShowMapOptions")) %>'
						EnableZoom='<%# Convert.ToBoolean(Eval("ShowZoomTool")) %>'
						ShowInfoWindow='<%# Convert.ToBoolean(Eval("ShowLocationInfo")) %>'
						EnableLocalSearch='false'
						EnableDrivingDirections='<%# Convert.ToBoolean(Eval("UseDrivingDirections")) %>'
						GmapType='<%# (mojoPortal.Web.Controls.google.MapType)Enum.Parse(typeof(mojoPortal.Web.Controls.google.MapType), Eval("MapType").ToString()) %>'
						ZoomLevel='<%# Convert.ToInt32(Eval("MapZoom")) %>'
						MapHeight='<%# Convert.ToInt32(Eval("MapHeight").ToString()) %>'
						MapWidth='<%# Eval("MapWidth").ToString() %>'>
					</portal:LocationMap>

					<portal:BingMap runat="server"
						ID="bmap"
						Visible='<%# ((Eval("Location").ToString().Length > 0)&&(ShowGoogleMap && Convert.ToBoolean(Eval("UseBingMap")))) %>'
						Location='<%# Eval("Location") %>'
						MapStyle='<%# BlogConfiguration.GetBingMapType(Eval("MapType").ToString()) %>'
						Height='<%# Convert.ToInt32(Eval("MapHeight").ToString()) %>'
						MapWidth='<%# Eval("MapWidth").ToString() %>'
						ShowGetDirections='<%# Convert.ToBoolean(Eval("UseDrivingDirections")) %>'
						Zoom='<%# Convert.ToInt32(Eval("MapZoom")) %>'
						ShowMapControls='<%# Convert.ToBoolean(Eval("ShowMapOptions")) %>'
						ShowLocationPin='<%# Convert.ToBoolean(Eval("ShowLocationInfo")) %>' />

					<asp:Panel runat="server"
						ID="pnlAvatar"
						EnableViewState="false"
						Visible='<%# !disableAvatars && !displaySettings.HideAvatarInPostList && ( (Convert.ToBoolean(Eval("ShowAuthorAvatar"))) || ((Convert.ToBoolean(Eval("ShowAuthorBio")))) ) %>'
						CssClass="avatarwrap authorinfo">
						<portal:Avatar runat="server"
							ID="av1"
							UseLink='<%# UseProfileLink() %>'
							MaxAllowedRating='<%# MaxAllowedGravatarRating %>'
							AvatarFile='<%# Eval("AvatarUrl") %>'
							UserName='<%# Eval("Name") %>'
							UserId='<%# Convert.ToInt32(Eval("UserID")) %>'
							SiteId='<%# SiteId %>'
							SiteRoot='<%# SiteRoot %>'
							Email='<%# Eval("Email") %>'
							UserNameTooltipFormat='<%# UserNameTooltipFormat %>'
							Disable='<%# disableAvatars || displaySettings.HideAvatarInPostList || !Convert.ToBoolean(Eval("ShowAuthorAvatar")) %>'
							UseGravatar='<%# allowGravatars %>' />

						<span runat="server"
							class="authorbio"
							enableviewstate="false"
							id="spnAuthorBio"
							visible='<%# displaySettings.ShowAuthorBioInPostList && Convert.ToBoolean(Eval("ShowAuthorBio")) %>'>
							<%# Eval("AuthorBio") %>
						</span>
					</asp:Panel>

					<% if (displaySettings.PostListUseBottomDate)
						{ %>

					<div class="blogdate">
						<span class="blogauthor" id="spnAuthor" runat="server" enableviewstate="false" visible='<%# Convert.ToBoolean(Eval("ShowAuthorName"))  %>'>
							<%# FormatPostAuthor(Convert.ToBoolean(Eval("ShowAuthorName")),Eval("Name").ToString(),Eval("FirstName").ToString(),Eval("LastName").ToString())%>
						</span>
						<span class="bdate" id="spnBottomDate" runat="server" enableviewstate="false" visible='<%# !displaySettings.PostListHideDate %>'>
							<%# FormatBlogDate(Convert.ToDateTime(Eval("StartDate"))) %>
						</span>

						<asp:Repeater ID="rptBottomCategories" runat="server" Visible='<%# displaySettings.ShowTagsOnPostList %>'>
							<HeaderTemplate>
								<span class="blogtags tagslabel">
									<mp:SiteLabel runat="server"
										ID="lblcatBottom"
										ConfigKey='<%# CategoriesResourceKey %>'
										ResourceFile="BlogResources"
										UseLabelTag="false"
										ShowWarningOnMissingKey="false" />
								</span>
								<span class="blogtags">
							</HeaderTemplate>

							<ItemTemplate>
								<asp:HyperLink runat="server"
									ID="Hyperlink5"
									EnableViewState="false"
									Text='<%# Eval("Category").ToString() %>'
									NavigateUrl='<%# this.SiteRoot +
										"/Blog/ViewCategory.aspx?cat=" +
										DataBinder.Eval(Container.DataItem,"CategoryID") +
										"&amp;pageid=" +
										PageId.ToString() +
										"&amp;mid=" +
										ModuleId.ToString()
									%>'>
								</asp:HyperLink>
							</ItemTemplate>

							<FooterTemplate>
								</span>
							</FooterTemplate>
						</asp:Repeater>
					</div>

					<% } %>

					<portal:mojoRating runat="server"
						ID="Rating2"
						Enabled='<%# EnableContentRating && displaySettings.UseBottomContentRating %>'
						ContentGuid='<%# new Guid(Eval("BlogGuid").ToString()) %>'
						AllowFeedback='false' />

					<div class="bsocial">
						<portal:AddThisWidget runat="server"
							ID="addThisWidget"
							AccountId='<%# addThisAccountId %>'
							SkinID="BlogList"
							TitleOfUrlToShare='<%# DataBinder.Eval(Container.DataItem,"Heading") %>'
							UrlToShare='<%# FormatBlogTitleUrl(DataBinder.Eval(Container.DataItem,"ItemUrl").ToString(), Convert.ToInt32(DataBinder.Eval(Container.DataItem,"ItemID"))) %>'
							Visible='<%# (!Config.HideAddThisButton) %>'
							EnableViewState="false" />

						<portal:TweetThisLink runat="server"
							ID="tt1"
							Visible='<%# ShowTweetThisLink %>'
							UrlToTweet='<%# FormatBlogTitleUrl(DataBinder.Eval(Container.DataItem,"ItemUrl").ToString(), Convert.ToInt32(DataBinder.Eval(Container.DataItem,"ItemID"))) %>'
							TitleToTweet='<%# DataBinder.Eval(Container.DataItem,"Heading") %>' />

						<portal:FacebookLikeButton runat="server"
							ID="fbl1"
							Visible='<%# UseFacebookLikeButton %>'
							UrlToLike='<%# FormatBlogTitleUrl(DataBinder.Eval(Container.DataItem,"ItemUrl").ToString(), Convert.ToInt32(DataBinder.Eval(Container.DataItem,"ItemID"))) %>'
							ColorScheme='<%# Config.FacebookLikeButtonTheme %>'
							ShowFaces='<%# Config.FacebookLikeButtonShowFaces %>'
							WidthInPixels='<%# Config.FacebookLikeButtonWidth %>'
							HeightInPixels='<%# Config.FacebookLikeButtonHeight %>' />

						<portal:PlusOneButton runat="server"
							ID="btnPlusOne"
							TargetUrl='<%# FormatBlogTitleUrl(DataBinder.Eval(Container.DataItem,"ItemUrl").ToString(), Convert.ToInt32(DataBinder.Eval(Container.DataItem,"ItemID"))) %>'
							Visible='<%# ShowPlusOneButton %>'
							SkinID="BlogPostList" />
					</div>

					<div id="blogCommentLink" runat="server" visible='<%# AllowComments %>' class="blogcommentlink">
						<asp:HyperLink runat="server"
							ID="Hyperlink2"
							EnableViewState="false"
							Text='<%# FeedBackLabel + "(" + DataBinder.Eval(Container.DataItem,"CommentCount") + ")" %>'
							Visible='<%# AllowComments && ShowCommentCounts %>'
							NavigateUrl='<%# FormatBlogUrl(DataBinder.Eval(Container.DataItem,"ItemUrl").ToString(), Convert.ToInt32(DataBinder.Eval(Container.DataItem,"ItemID")))  %>'
							CssClass="blogcommentlink"></asp:HyperLink>

						<asp:HyperLink runat="server"
							ID="Hyperlink1"
							EnableViewState="false"
							Text='<%# FeedBackLabel %>'
							Visible='<%# Config.AllowComments && !ShowCommentCounts %>'
							NavigateUrl='<%# FormatBlogUrl(DataBinder.Eval(Container.DataItem,"ItemUrl").ToString(), Convert.ToInt32(DataBinder.Eval(Container.DataItem,"ItemID")))  %>'
							CssClass="blogcommentlink"></asp:HyperLink>
					</div>
				</asp:Panel>
			</blog:BlogPostListItemPanel>
		</ItemTemplate>
	</asp:Repeater>

	<div class="blogpager">
		<portal:mojoCutePager ID="pgr" runat="server" />
	</div>
</blog:BlogPostListWrapperPanel>

<blog:NavControl ID="navBottom" runat="server" />

<div class="blogcopyright">
	<asp:Label ID="lblCopyright" runat="server" />
</div>

<portal:DisqusWidget ID="disqus" runat="server" />
