# Man Parvesh's Technical Journal

A technical blog focused on software engineering, system design, and technology innovations. Built with Hugo and styled with LaTeX.css for clean, academic typography.

🌐 **Live Site**: [blog.manparvesh.com](https://blog.manparvesh.com/)

## About

This blog features deep dives into:
- Software engineering practices and patterns
- Distributed systems and databases
- System design and architecture
- Paper summaries and technical research
- Personal projects and productivity tools

## Technical Stack

- **Static Site Generator**: Hugo (v0.83.0+)
- **Styling**: [LaTeX.css](https://latex.vercel.app/) for academic typography
- **Comments**: [Giscus](https://giscus.app/) (GitHub Discussions-based)
- **Analytics**: Google Analytics
- **Hosting**: GitHub Pages
- **Build**: Automated with Makefile

## Content Organization

```
content/
├── posts/          # Technical blog posts
├── series/         # Multi-part article series
├── tags/           # Topic-based organization
└── about/          # About page
```

### Featured Series

- **Paper Summaries**: Technical paper analyses and summaries
- **Large-scale Distributed Systems**: System design deep dives
- **Yoda**: CLI tool development journey
- **Productivity**: Workflow optimization and tools

## Features

- **Clean Typography**: LaTeX.css provides beautiful academic styling
- **Fast Loading**: Minimal JavaScript, lightweight design
- **Academic Footnotes**: Proper numbered footnotes with backlinks
- **Responsive Design**: Mobile-friendly layout
- **GitHub-based Comments**: Community discussions via Giscus
- **SEO Optimized**: Proper meta tags and structured data
- **RSS Feed**: Stay updated with new posts

## Development

### Local Development

```bash
# Clone the repository
git clone https://github.com/manparvesh/blog.manparvesh.com.git
cd blog.manparvesh.com

# Start development server
make serve

# Build for production
make build
```

### Project Structure

- `layouts/` - Hugo templates and partials
- `assets/` - SCSS stylesheets and JavaScript
- `static/` - Static assets (fonts, images, favicon)
- `exampleSite/content/` - Blog posts and content
- `docs/` - Generated static site (GitHub Pages)

## Configuration

Key settings in `exampleSite/config.yaml`:

```yaml
baseurl: "https://blog.manparvesh.com/"
title: "Man Parvesh's Technical Journal"
params:
  subtitle: "Deep dives into software engineering, system design, and technology innovations"
  copyright: "Copyright 2025 Man Parvesh Singh Randhawa"
  giscus:
    enable: true
    repo: "manparvesh/blog.manparvesh.com"
```

## Writing

### Post Front Matter

```yaml
---
title: "Your Post Title"
date: 2025-01-01
meta: true      # Show metadata (date, tags)
toc: true       # Show table of contents
tags: ["hugo", "blogging", "technology"]
series: ["series-name"]  # Optional
---
```

### Footnotes

Standard Markdown footnotes are supported:

```markdown
This is a statement[^1].

[^1]: This is the footnote content.
```

## Contact & Social

- **LinkedIn**: [linkedin.com/in/manparvesh](https://linkedin.com/in/manparvesh)
- **GitHub**: [github.com/manparvesh](https://github.com/manparvesh)
- **Website**: [manparvesh.com](https://manparvesh.com)

## License

MIT License - see [LICENSE](LICENSE) for details.

## Credits

- Typography: [LaTeX.css](https://latex.vercel.app/)
- Comments: [Giscus](https://giscus.app/)
- Static site generator: [Hugo](https://gohugo.io/)