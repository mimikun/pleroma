(window.webpackJsonp=window.webpackJsonp||[]).push([[21],{729:function(e,t,a){"use strict";a.r(t),a.d(t,"default",function(){return A});var s,i,o,n=a(0),r=a.n(n),l=a(6),d=a.n(l),u=a(3),c=a.n(u),g=a(7),f=a.n(g),m=(a(1),a(193)),b=a(698),p=a(697),_=a(4),v=a(12),h=a(2),M=a.n(h),w=a(17),y=a.n(w),k=a(18),q=a(10),P=a(13),x=a(189),R=a(5),F=a(810),N=a(695),j=Object(_.f)({home_timeline:{id:"tabs_bar.home",defaultMessage:"Home"},notifications:{id:"tabs_bar.notifications",defaultMessage:"Notifications"},public_timeline:{id:"navigation_bar.public_timeline",defaultMessage:"Federated timeline"},settings_subheading:{id:"column_subheading.settings",defaultMessage:"Settings"},community_timeline:{id:"navigation_bar.community_timeline",defaultMessage:"Local timeline"},direct:{id:"navigation_bar.direct",defaultMessage:"Direct messages"},preferences:{id:"navigation_bar.preferences",defaultMessage:"Preferences"},follow_requests:{id:"navigation_bar.follow_requests",defaultMessage:"Follow requests"},favourites:{id:"navigation_bar.favourites",defaultMessage:"Favourites"},blocks:{id:"navigation_bar.blocks",defaultMessage:"Blocked users"},domain_blocks:{id:"navigation_bar.domain_blocks",defaultMessage:"Hidden domains"},mutes:{id:"navigation_bar.mutes",defaultMessage:"Muted users"},pins:{id:"navigation_bar.pins",defaultMessage:"Pinned toots"},lists:{id:"navigation_bar.lists",defaultMessage:"Lists"},discover:{id:"navigation_bar.discover",defaultMessage:"Discover"},personal:{id:"navigation_bar.personal",defaultMessage:"Personal"},security:{id:"navigation_bar.security",defaultMessage:"Security"},menu:{id:"getting_started.heading",defaultMessage:"Getting started"}}),A=Object(v.connect)(function(e){return{myAccount:e.getIn(["accounts",q.i]),unreadFollowRequests:e.getIn(["user_lists","follow_requests","items"],Object(R.List)()).size,customPanelEnabled:e.getIn(["custom_panel","enabled"]),customPanel:e.getIn(["custom_panel","panel"])}},function(e){return{fetchFollowRequests:function(){return e(Object(P.x)())},fetchPanel:function(){return e(Object(x.c)())},fetchPleromaConfig:function(){return e(Object(x.d)())}}})(s=Object(_.g)((o=i=function(e){function t(){return d()(this,t),c()(this,e.apply(this,arguments))}return f()(t,e),t.prototype.componentDidMount=function(){var e=this.props,t=e.myAccount,a=e.fetchFollowRequests,s=e.fetchPleromaConfig,i=e.fetchPanel;t.get("locked")&&a(),s(),i()},t.prototype.render=function(){var e,t,a=this.props,s=a.intl,i=a.myAccount,o=a.multiColumn,n=a.unreadFollowRequests,l=a.customPanelEnabled,d=a.customPanel,u=[],c=1,g=o?0:60;o&&(u.push(r()(p.a,{text:s.formatMessage(j.discover)},c++),r()(b.a,{icon:"users",text:s.formatMessage(j.community_timeline),to:"/timelines/public/local"},c++),r()(b.a,{icon:"globe",text:s.formatMessage(j.public_timeline),to:"/timelines/public"},c++),r()(p.a,{text:s.formatMessage(j.personal)},c++)),g+=164),u.push(r()(b.a,{icon:"envelope",text:s.formatMessage(j.direct),to:"/timelines/direct"},c++),r()(b.a,{icon:"star",text:s.formatMessage(j.favourites),to:"/favourites"},c++),r()(b.a,{icon:"list-ul",text:s.formatMessage(j.lists),to:"/lists"},c++)),g+=144,i.get("locked")&&(u.push(r()(b.a,{icon:"users",text:s.formatMessage(j.follow_requests),badge:(e=n,t=40,0===e?void 0:t&&e>=t?t+"+":e),to:"/follow_requests"},c++)),g+=48),o||(u.push(r()(p.a,{text:s.formatMessage(j.settings_subheading)},c++),r()(b.a,{icon:"gears",text:s.formatMessage(j.preferences),href:"/user-settings"},c++)),g+=82);var f=l?r()("div",{dangerouslySetInnerHTML:{__html:d},style:{marginLeft:-12,marginRight:-12}}):r()("p",{},void 0,r()("a",{href:"https://github.com/tootsuite/documentation/blob/master/Using-Mastodon/FAQ.md",rel:"noopener",target:"_blank"},void 0,r()(_.b,{id:"getting_started.faq",defaultMessage:"FAQ"}))," • ",r()("a",{href:"https://github.com/tootsuite/documentation/blob/master/Using-Mastodon/User-guide.md",rel:"noopener",target:"_blank"},void 0,r()(_.b,{id:"getting_started.userguide",defaultMessage:"User Guide"}))," • ",r()("a",{href:"https://github.com/tootsuite/documentation/blob/master/Using-Mastodon/Apps.md",rel:"noopener",target:"_blank"},void 0,r()(_.b,{id:"getting_started.appsshort",defaultMessage:"Apps"}))," • ",r()("a",{href:"https://pleroma.social"},void 0,r()(_.b,{id:"getting_started.pleroma",defaultMessage:"Pleroma"})));return r()(m.a,{label:s.formatMessage(j.menu)},void 0,o&&r()("div",{className:"column-header__wrapper"},void 0,r()("h1",{className:"column-header"},void 0,r()("button",{},void 0,r()("i",{className:"fa fa-bars fa-fw column-header__icon"}),r()(_.b,{id:"getting_started.heading",defaultMessage:"Getting started"})))),r()("div",{className:"getting-started__wrapper scrollable",style:{height:g}},void 0,!o&&r()(N.a,{account:i}),u),!o&&r()("div",{className:"flex-spacer"}),r()("div",{className:"getting-started getting-started__panel scrollable"},void 0,f),!o&&r()("div",{className:"flex-spacer"}),r()("div",{className:"getting-started__footer scrollable"},void 0,r()("ul",{},void 0,q.g&&r()("li",{},void 0,r()("a",{href:"/invites",target:"_blank"},void 0,r()(_.b,{id:"getting_started.invite",defaultMessage:"Invite people"}))," · "),o&&r()("li",{},void 0,r()(F.a,{to:"/keyboard-shortcuts"},void 0,r()(_.b,{id:"navigation_bar.keyboard_shortcuts",defaultMessage:"Hotkeys"}))," · "),r()("li",{},void 0,r()("a",{href:"/auth/sign_out","data-method":"delete"},void 0,r()(_.b,{id:"navigation_bar.logout",defaultMessage:"Logout"})))),r()("p",{},void 0,r()(_.b,{id:"getting_started.mastofe_notice",defaultMessage:"{mastofe} is libre software based on {mastodon} frontend adapted for {pleroma}.",values:{mastofe:r()("a",{href:"https://git.pleroma.social/pleroma/mastofe",rel:"noopener",target:"_blank"},void 0,"Mastofe"),mastodon:r()("a",{href:"https://github.com/tootsuite/mastodon",rel:"noopener",target:"_blank"},void 0,"Mastodon"),pleroma:r()("a",{href:"https://pleroma.social",rel:"noopener",target:"_blank"},void 0,"Pleroma")}}))))},t}(k.a),i.propTypes={intl:M.a.object.isRequired,myAccount:y.a.map.isRequired,columns:y.a.list,multiColumn:M.a.bool,fetchFollowRequests:M.a.func.isRequired,fetchPanel:M.a.func.isRequired,fetchPleromaConfig:M.a.func.isRequired,unreadFollowRequests:M.a.number,unreadNotifications:M.a.number,customPanelEnabled:M.a.bool,customPanel:M.a.string.isRequired},s=o))||s)||s}}]);
//# sourceMappingURL=getting_started.js.map