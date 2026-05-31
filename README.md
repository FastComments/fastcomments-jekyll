# fastcomments-jekyll

A fast, full-featured live commenting widget for [Jekyll](https://jekyllrb.com), powered by [FastComments](https://fastcomments.com).

Adds Liquid tags like `{% raw %}{% fastcomments %}{% endraw %}` that you drop straight into your templates and posts.

## Live Demo

Try every widget live at <https://fastcomments.com/commenting-system-for-jekyll>.

## Live Showcase

To see every tag running locally against the public `demo` tenant, clone the repo and run:

```bash
cd example
bundle install
bundle exec jekyll serve
```

Each widget has its own page under `example/` that you can copy straight into your own Jekyll site.

## Install

[![Gem](https://img.shields.io/gem/v/fastcomments-jekyll?logo=rubygems&label=gem&color=e9573f)](https://rubygems.org/gems/fastcomments-jekyll)

Add the gem to the `:jekyll_plugins` group in your site's `Gemfile`:

```ruby
group :jekyll_plugins do
  gem "fastcomments-jekyll"
end
```

Then:

```bash
bundle install
```

(Compatible with Jekyll 3.7+ and 4.x.)

## Quick Start

Set your tenant id once in `_config.yml`:

```yaml
fastcomments:
  tenant_id: demo
```

Then add a tag wherever you want the widget — in a layout, a post, or a page:

```liquid
{% raw %}{% fastcomments %}{% endraw %}
```

That's it. Replace `demo` with your FastComments tenant id (find it under
[Settings > API/SSO](https://fastcomments.com/auth/my-account/api)).

## Tags

| Tag | Description |
| --- | --- |
| `fastcomments` | Live commenting widget with replies, voting, and more |
| `fastcomments_comment_count` | Comment count for the current page |
| `fastcomments_comment_count_bulk` | Comment counts for many pages on one list/index page |
| `fastcomments_live_chat` | Realtime streaming chat widget |
| `fastcomments_collab_chat` | Collaborative inline commenting (text annotations) |
| `fastcomments_image_chat` | Image annotation comments |
| `fastcomments_recent_comments` | Recent comments across the site |
| `fastcomments_recent_discussions` | Recently active discussion threads |
| `fastcomments_reviews_summary` | Star-rating reviews summary |
| `fastcomments_top_pages` | Most-discussed pages |
| `fastcomments_user_activity_feed` | Per-user activity feed |

### Examples

```liquid
{% raw %}{# Comment count — the widget renders its own label, e.g. "0 comments" #}
{% fastcomments_comment_count %}

{# Live chat #}
{% fastcomments_live_chat %}

{# Collab chat — point it at a content element with a CSS selector #}
<article id="post-body">
  <p>Highlight me to leave a comment.</p>
</article>
{% fastcomments_collab_chat target="#post-body" %}

{# Image chat — point it at an image element with a CSS selector #}
<img id="hero" src="/hero.jpg" alt="Hero image">
{% fastcomments_image_chat target="#hero" %}

{# Reviews summary #}
{% fastcomments_reviews_summary %}

{# User activity feed — requires a user id #}
{% fastcomments_user_activity_feed user_id="demo:demo-user" %}

{# Bulk comment counts for a blog index #}
{% for post in site.posts %}
  <a href="{{ post.url }}">{{ post.title }}</a>
  <span class="fast-comments-count" data-fast-comments-url-id="{{ post.url }}"></span>
{% endfor %}
{% fastcomments_comment_count_bulk %}{% endraw %}
```

## Configuration

Config comes from three places. Later sources win:

1. **Global defaults** in `_config.yml` under the `fastcomments:` key.
2. **Page context**, derived automatically for page-scoped widgets (see below).
3. **Tag attributes** written on the tag itself.

So a `url_id` on the tag overrides the page-derived value, which overrides any global default.

### Attribute syntax

Attributes are `key=value` pairs in `snake_case`:

```liquid
{% raw %}{% fastcomments url_id="my-stable-id" readonly=true count=20 %}{% endraw %}
```

- **Quoted** values (`"..."` or `'...'`) are literal strings.
- **Unquoted** `true`/`false` become booleans, and numbers become numbers.
- **Unquoted** anything else is resolved as a Liquid variable from the page context, e.g.
  `url_id=page.slug`. (Liquid does not expand `{% raw %}{{ ... }}{% endraw %}` inside a tag's
  attributes, so use the bare `page.slug` form rather than `"{% raw %}{{ page.slug }}{% endraw %}"`.)

Snake_case attribute and config keys are mapped automatically to the camelCase keys FastComments
expects (`tenant_id` → `tenantId`, `url_id` → `urlId`, `page_title` → `pageTitle`,
`has_dark_background` → `hasDarkBackground`, and so on). Any other option from the
[widget configuration](https://docs.fastcomments.com/guide-customizations-and-configuration.html)
passes straight through the same way.

### Page-derived values

For the page-scoped widgets (`fastcomments`, `fastcomments_comment_count`, `fastcomments_live_chat`,
`fastcomments_collab_chat`, `fastcomments_image_chat`) these are filled in automatically from the
current page unless you set them yourself:

- `url_id` ← `page.url` (a stable identifier independent of the visiting domain)
- `url` ← `site.url` + `page.url` (only when `url` is set in `_config.yml`)
- `page_title` ← `page.title`

Site-wide widgets (recent comments/discussions, top pages, reviews summary, user activity feed,
bulk count) are not tied to a page and do not derive these.

### EU data residency

EU customers add `region: eu` — either globally:

```yaml
fastcomments:
  tenant_id: your-tenant-id
  region: eu
```

or per tag: `{% raw %}{% fastcomments region="eu" %}{% endraw %}`. Widgets then load from the EU CDN.

## Links

- [FastComments Documentation](https://docs.fastcomments.com)
- [Customization & Configuration](https://docs.fastcomments.com/guide-customizations-and-configuration.html)
- [Jekyll Documentation](https://jekyllrb.com/docs/)

## License

MIT

## Maintenance Status

These components are wrappers around our core VanillaJS components. We can automatically update those components (fix bugs, add features) without publishing this library, so while it may not be published for a while that does not mean FastComments is not under active development! Feel free to check [our blog](https://blog.fastcomments.com/) for updates. Breaking API changes or features will never be shipped to the underlying core library without a version bump in this library.
