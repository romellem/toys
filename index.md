---
---
<ul>
{% for page in site.pages %}
  {% if page.dir == '/' or page.dir contains '/assets/' %}
  {% else %}
  <li><a href="{{ page.dir | remove_first: '/' }}">{{ page.dir | remove_first: '/' }}</a></li>
  {% endif %}
{% endfor %}
</ul>