# Builds every page of the Shree Anurag Enterprises site.
# Run from anywhere:  powershell -File "_build\build.ps1"
# Edit the shared header/footer or page content here, then re-run.
$ErrorActionPreference = 'Stop'
$Root = Split-Path $PSScriptRoot -Parent
$Src  = Join-Path $PSScriptRoot 'source'
$utf8 = New-Object System.Text.UTF8Encoding($false)

$WA_NUMBER = '919811654647'
$DESC = 'Shree Anurag Enterprises - family-owned importer and distributor of Cormenflex, Marksman and Tailong cutting wheels, grinding wheels, abrasives and power tools since 1996. Delhi, India.'

function WaLink($text) { "https://wa.me/$WA_NUMBER" + '?text=' + [uri]::EscapeDataString($text) }

# ---------- Shared page shell ----------
function Page($rel, $title, $active, $body, $bodyClass = '') {
  $depth = ($rel.Split('/').Count - 1)
  $p = ('../' * $depth)
  function Nav($name, $href) { $c = ''; if ($name -eq $active) { $c = ' class="active"' }; "<a href=`"{P}$href`"$c>$name</a>" }

  $footer = @"
  <footer class="site-footer">
    <div class="wrap footer-grid">
      <div>
        <a class="footer-logo" href="{P}index.html"><span class="logo-mark">SA</span><span class="logo-text">Shree Anurag<small>Enterprises</small></span></a>
        <p>Importer &amp; distributor of premium cutting wheels, grinding wheels, abrasives and power-tools under the Marksman, Cormenflex &amp; Tailong brands. Family-owned since 1996.</p>
      </div>
      <div>
        <h4>Quick Links</h4>
        <ul>
          <li><a href="{P}index.html">Home</a></li>
          <li><a href="{P}products.html">All Products</a></li>
          <li><a href="{P}about.html">About Us</a></li>
          <li><a href="{P}contact.html">Contact</a></li>
        </ul>
      </div>
      <div>
        <h4>Our Brands</h4>
        <ul>
          <li><a href="{P}cormenflex.html">Cormenflex</a></li>
          <li><a href="{P}marksman.html">Marksman</a></li>
          <li><a href="{P}tailong.html">Tailong</a></li>
        </ul>
      </div>
      <div>
        <h4>Get in Touch</h4>
        <ul class="contact-lines">
          <li><i class="fa-solid fa-location-dot"></i><span>&ldquo;Paras Bhawan&rdquo;, 3944, Behind G.B. Road, Delhi 110006, India</span></li>
          <li><i class="fa-solid fa-phone"></i><a href="tel:+919811654647">India: +91 98116 54647</a></li>
          <li><i class="fa-solid fa-phone"></i><a href="tel:+19843639653">USA: +1 (984) 363-9653</a></li>
          <li><i class="fa-solid fa-phone"></i><a href="tel:+971552901681">Dubai: +971 55 290 1681</a></li>
          <li><i class="fa-solid fa-envelope"></i><a href="mailto:info@cormenflex.com">shreeanurag@gmail.com</a></li>
        </ul>
      </div>
    </div>
    <div class="footer-bottom">
      <div class="wrap">
        <span>&copy; 2026 Shree Anurag Enterprises. All rights reserved.</span>
        <span>Family-owned since 1996 &middot; Delhi, India</span>
      </div>
    </div>
  </footer>
"@
  # The product-lines page fits one screen, so it has no footer
  $bodyAttr = ''
  if ($bodyClass) { $footer = ''; $bodyAttr = " class=`"$bodyClass`"" }

  $html = @"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>$title</title>
  <meta name="description" content="$DESC">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
  <link rel="stylesheet" href="{P}style.css">
</head>
<body$bodyAttr>
  <header class="site-header">
    <div class="wrap header-inner">
      <a class="logo" href="{P}index.html"><span class="logo-mark">SA</span><span class="logo-text">Shree Anurag<small>Enterprises</small></span></a>
      <button class="menu-toggle" aria-label="Open menu"><i class="fa-solid fa-bars"></i></button>
      <nav class="main-nav">
        $(Nav 'Home' 'index.html')
        $(Nav 'Products' 'products.html')
        $(Nav 'Brands' 'index.html#brands')
        $(Nav 'About' 'about.html')
        $(Nav 'Contact' 'contact.html')
        <a class="btn btn-sm" href="{P}contact.html">Enquire Now</a>
      </nav>
    </div>
  </header>

  <main>
$body
  </main>

$footer
  <a class="wa-float" href="$(WaLink 'Hello Shree Anurag Enterprises, I would like to enquire about your products.')" target="_blank" rel="noopener" aria-label="Chat on WhatsApp"><i class="fa-brands fa-whatsapp"></i></a>
  <script src="{P}site.js"></script>
</body>
</html>
"@
  $html = $html.Replace('{P}', $p)
  $out = Join-Path $Root ($rel.Replace('/', '\'))
  New-Item -ItemType Directory -Force (Split-Path $out -Parent) | Out-Null
  [IO.File]::WriteAllText($out, $html, $utf8)
  "built $rel"
}

function Banner($title, $crumbs) {
  @"
    <section class="page-banner">
      <div class="wrap">
        <h1>$title</h1>
        <p class="crumbs">$crumbs</p>
      </div>
    </section>
"@
}

# ---------- Product catalogue ----------
$products = @(
  @{ slug='abrasives/cut12x2';           brand='Marksman';   name='Marksman Cutting Wheel 12&quot; &times; 2 mm';        img='images/cutting/cut12x2.jpg';            grit='A46TBF'; fb='images/marksman-logo.png' },
  @{ slug='abrasives/cut14x2-5';         brand='Marksman';   name='Marksman Cutting Wheel 14&quot; &times; 2.5 mm';      img='images/cutting/cut14x2-5.jpg';          grit='A46TBF'; fb='images/marksman-logo.png' },
  @{ slug='cormenflex/cut105x1-2';       brand='Cormenflex'; name='Cormenflex Gold Cutting Wheel 105 mm &times; 1.2 mm'; img='images/cormenflex/cut105x1-2.jpg';      fb='images/cormenflex-logo.png' },
  @{ slug='cormenflex/cut350x2-5';       brand='Cormenflex'; name='Cormenflex Gold Rail-Cutting Wheel 350 mm &times; 2.5 mm'; img='images/cormenflex/cut350x2-5.jpg'; fb='images/cormenflex-logo.png' },
  @{ slug='cormenflex/grind100x6';       brand='Cormenflex'; name='Cormenflex DCD Grinding Wheel 100 &times; 6 mm';      img='images/cormenflex/grind100x6.jpg';      fb='images/cormenflex-logo.png' },
  @{ slug='tailong/black-dcd-wheel';     brand='Tailong';    name='Tailong Black DCD Wheels';                           img='images/tailong/black-dcd-wheel.png';    fb='images/tailong-logo.png' },
  @{ slug='tailong/black-parting-wheel'; brand='Tailong';    name='Tailong Black Reinforced Parting Wheels';            img='images/tailong/black-parting-wheel.png'; fb='images/tailong-logo.png' },
  @{ slug='tailong/black-thin-cut';      brand='Tailong';    name='Tailong Black Thin-Cut Wheels';                      img='images/tailong/black-thin-cut.png';     fb='images/tailong-logo.png' },
  @{ slug='tailong/flexible-wheel';      brand='Tailong';    name='Tailong Green Flexible Wheel 105 &times; 2.5 mm';     img='images/tailong/flexible-wheel.png';     fb='images/tailong-logo.png' },
  @{ slug='tailong/green-dcd-wheel';     brand='Tailong';    name='Tailong Green DCD Wheels';                           img='images/tailong/green-dcd-wheel-family.png'; fb='images/tailong-logo.png' },
  @{ slug='tailong/thin-cut-double';     brand='Tailong';    name='Tailong Green Thin-Cut Wheels &bull; Double-Net';    img='images/tailong/thin-cut-double-net.png'; fb='images/tailong-logo.png' },
  @{ slug='tailong/thin-cut-single';     brand='Tailong';    name='Tailong Green Thin-Cut Wheels &bull; Single-Net';    img='images/tailong/thin-cut-single-net.png'; fb='images/tailong-logo.png' }
)
$brandPage = @{ Cormenflex = 'cormenflex.html'; Marksman = 'marksman.html'; Tailong = 'tailong.html' }

# Use the brand logo where the product photo is missing (also missing on cormenflex.com)
function ImgFor($pr) {
  if (Test-Path (Join-Path $Root $pr.img)) { return @($pr.img, '') }
  return @($pr.fb, ' class="fallback"')
}

function Card($pr) {
  $i = ImgFor $pr
  $grit = ''
  if ($pr.grit) { $grit = "<p class=`"grit`">Grit $($pr.grit)</p>" }
  @"
        <a class="product-card" href="{P}products/$($pr.slug).html">
          <div class="thumb"><img src="{P}$($i[0])"$($i[1]) alt="$($pr.name)" loading="lazy"></div>
          <div class="info"><h3>$($pr.name)</h3>$grit<span class="more">View Details &rarr;</span></div>
        </a>
"@
}

function FilterBar($active) {
  $items = @(@('All Products','products.html'), @('Cormenflex','cormenflex.html'), @('Marksman','marksman.html'), @('Tailong','tailong.html'))
  $links = $items | ForEach-Object { $c = ''; if ($_[0] -eq $active) { $c = ' class="active"' }; "<a href=`"{P}$($_[1])`"$c>$($_[0])</a>" }
  "      <div class=`"filter-bar`">$($links -join '')</div>"
}

function Listing($rel, $title, $crumb, $active, $list, $intro = '') {
  $cards = ($list | ForEach-Object { Card $_ }) -join "`n"
  $body = (Banner $title "<a href=`"{P}index.html`">Home</a> / $crumb") + @"

    <section class="section">
      <div class="wrap">
$(FilterBar $active)
$intro
        <div class="product-grid">
$cards
        </div>
      </div>
    </section>
"@
  Page $rel "$title | Shree Anurag Enterprises" 'Products' $body
}

# ---------- Shared blocks ----------
$offerWhy = @'
        <div class="two-col">
          <div class="panel">
            <h3>What We Offer</h3>
            <ul class="bullets">
              <li><i class="fa-solid fa-circle-check"></i>Tailong Green &amp; Black Series thin-cut wheels</li>
              <li><i class="fa-solid fa-circle-check"></i>Cormenflex Gold, Green &amp; Standard grinding wheels</li>
              <li><i class="fa-solid fa-circle-check"></i>Vitrified straight, cup, centreless &amp; cylindrical wheels</li>
              <li><i class="fa-solid fa-circle-check"></i>Flap discs, Velcro/DA sanding discs &amp; &ldquo;Magic Series&rdquo; abrasives</li>
              <li><i class="fa-solid fa-circle-check"></i>Diamond/CBN blades, TCT saws &amp; turbo blades for concrete</li>
            </ul>
            <p class="note">Every batch is ISO-tested in-house and shipped with full after-sales technical support.</p>
          </div>
          <div class="panel">
            <h3>Why Choose Us</h3>
            <ul class="bullets">
              <li><i class="fa-solid fa-circle-check"></i><span><strong>Reliability:</strong> Consistent wheel geometry, less vibration and longer spindle life.</span></li>
              <li><i class="fa-solid fa-circle-check"></i><span><strong>Honest Pricing:</strong> Transparent GST invoices with no hidden freight mark-ups.</span></li>
              <li><i class="fa-solid fa-circle-check"></i><span><strong>Service with a Human Touch:</strong> Same-day dispatch and technical guidance on call.</span></li>
              <li><i class="fa-solid fa-circle-check"></i><span><strong>Nation-wide Reach:</strong> Dealer network across every major industrial cluster.</span></li>
            </ul>
          </div>
        </div>
'@

$officeBlock = @'
        <div class="office-grid">
          <div class="panel">
            <ul class="info-list">
              <li><span class="ico"><i class="fa-solid fa-location-dot"></i></span><div><strong>Head Office</strong>&ldquo;Paras Bhawan&rdquo;, 3944, Behind G.B. Road, Delhi 110006, India</div></li>
              <li><span class="ico"><i class="fa-solid fa-phone"></i></span><div><strong>India</strong><a href="tel:+919811654647">+91 98116 54647</a></div></li>
              <li><span class="ico"><i class="fa-solid fa-phone"></i></span><div><strong>United States</strong><a href="tel:+19843639653">+1 (984) 363-9653</a></div></li>
              <li><span class="ico"><i class="fa-solid fa-phone"></i></span><div><strong>Dubai</strong><a href="tel:+971552901681">+971 55 290 1681</a></div></li>
              <li><span class="ico"><i class="fa-solid fa-envelope"></i></span><div><strong>Email</strong><a href="mailto:info@cormenflex.com">shreeanurag@gmail.com</a></div></li>
            </ul>
          </div>
          <div class="map-frame">
            <iframe title="Shree Anurag Enterprises on Google Maps" src="https://www.google.com/maps?q=Paras+Bhawan,+3944,+Behind+G.B.+Road,+Delhi+110006&output=embed" loading="lazy" allowfullscreen referrerpolicy="no-referrer-when-downgrade"></iframe>
          </div>
        </div>
'@

$waGeneral = WaLink 'Hello Shree Anurag Enterprises, I would like to enquire about your products.'
$waDealer  = WaLink 'Hello Shree Anurag Enterprises, I am interested in becoming a dealer.'

# ---------- Home ----------
$homeBody = @"
    <section class="carousel" aria-label="Highlights">
      <div class="slide active">
        <img src="{P}images/demolition-hammer.jpg" alt="Marksman power tools on site">
        <div class="slide-caption"><div class="wrap">
          <span class="slide-tag">Family-owned since 1996</span>
          <h1>Cutting &amp; Grinding, Done Right.</h1>
          <p>Importer and distributor of cutting wheels, grinding wheels, abrasives and power tools under the Cormenflex, Marksman and Tailong brands.</p>
          <div class="actions"><a class="btn btn-light" href="{P}product-lines.html">View Product Lines</a><a class="btn btn-outline" href="{P}index.html#about">Learn More</a></div>
        </div></div>
      </div>
      <div class="slide">
        <img src="{P}images/wheels.jpg" alt="Collection of cutting and grinding wheels" loading="lazy">
        <div class="slide-caption"><div class="wrap">
          <span class="slide-tag">Three trusted brands</span>
          <h2>Cormenflex &middot; Marksman &middot; Tailong</h2>
          <p>Thin-cut, DCD, parting and flexible wheels for steel, stainless and rail &mdash; every batch ISO-tested in-house.</p>
          <div class="actions"><a class="btn btn-light" href="{P}products.html">Browse Products</a></div>
        </div></div>
      </div>
      <div class="slide">
        <img src="{P}images/head-office.jpg" alt="Shree Anurag Enterprises head office, Delhi" loading="lazy">
        <div class="slide-caption"><div class="wrap">
          <span class="slide-tag">Delhi head office</span>
          <h2>Same-day Dispatch Across India</h2>
          <p>Transparent GST invoices, no hidden freight, and technical guidance on call.</p>
          <div class="actions"><a class="btn btn-light" href="{P}contact.html">Contact Us</a></div>
        </div></div>
      </div>
      <button class="car-arrow car-prev" aria-label="Previous slide"><i class="fa-solid fa-chevron-left"></i></button>
      <button class="car-arrow car-next" aria-label="Next slide"><i class="fa-solid fa-chevron-right"></i></button>
      <div class="car-dots"><button class="active" aria-label="Slide 1"></button><button aria-label="Slide 2"></button><button aria-label="Slide 3"></button></div>
    </section>

    <section class="section">
      <div class="wrap">
        <div class="section-head">
          <span class="eyebrow">What we supply</span>
          <h2>Our Products</h2>
          <p>Premium abrasives and power-tool solutions for every workshop.</p>
        </div>
        <div class="cat-grid">
          <a class="cat-card" href="{P}products.html">
            <div class="img"><img src="{P}images/tailong/thin-cut-single-net.png" alt="Thin-cut wheels" loading="lazy"></div>
            <div class="body"><h3>Cutting Wheels</h3><p>Thin-cut single and double-net wheels for fast, clean cuts on steel and stainless.</p><span class="more">View Details &rarr;</span></div>
          </a>
          <a class="cat-card" href="{P}products.html">
            <div class="img"><img src="{P}images/tailong/green-dcd-wheel-family.png" alt="DCD grinding wheels" loading="lazy"></div>
            <div class="body"><h3>Grinding Wheels</h3><p>Reinforced DCD grinding discs for quick stock removal with less vibration.</p><span class="more">View Details &rarr;</span></div>
          </a>
          <a class="cat-card" href="{P}products.html">
            <div class="img"><img src="{P}images/tailong/black-parting-wheel.png" alt="Parting and flexible wheels" loading="lazy"></div>
            <div class="body"><h3>Parting &amp; Flexible Wheels</h3><p>Reinforced parting wheels and flexible discs for demanding industrial work.</p><span class="more">View Details &rarr;</span></div>
          </a>
          <a class="cat-card" href="{P}marksman.html">
            <div class="img"><img src="{P}images/demolition-hammer.jpg" alt="Marksman power tools" loading="lazy"></div>
            <div class="body"><h3>Power Tools</h3><p>Marksman power tools and accessories built for site and workshop use.</p><span class="more">View Details &rarr;</span></div>
          </a>
        </div>
      </div>
    </section>

    <section class="section about-strip" id="about">
      <div class="wrap about-grid">
        <div>
          <span class="eyebrow">About us</span>
          <h2>Three Generations, One Promise</h2>
          <p>Founded in 1996 by <strong>Anil Kumar Jain</strong> and now run by his son <strong>Anurag Jain</strong>, Shree Anurag Enterprises has grown from a single-counter shop into one of India&rsquo;s most trusted suppliers of industrial abrasives and power-tool accessories.</p>
          <ul class="checks">
            <li><i class="fa-solid fa-circle-check"></i>Every batch ISO-tested in-house</li>
            <li><i class="fa-solid fa-circle-check"></i>Same-day dispatch</li>
            <li><i class="fa-solid fa-circle-check"></i>Transparent GST invoices</li>
            <li><i class="fa-solid fa-circle-check"></i>After-sales technical support</li>
          </ul>
          <a class="btn btn-light" href="{P}about.html">Read More</a>
        </div>
        <div class="about-photo"><img src="{P}images/head-office.jpg" alt="Shree Anurag Enterprises head office" loading="lazy"></div>
      </div>
    </section>

    <section class="section" id="brands">
      <div class="wrap">
        <div class="section-head">
          <span class="eyebrow">Our brands</span>
          <h2>Brands We Carry</h2>
        </div>
        <div class="brand-row">
          <a class="brand-tile" href="{P}cormenflex.html"><img src="{P}images/cormenflex-logo.png" alt="Cormenflex logo" loading="lazy"><h3>Cormenflex</h3><p>Gold-standard industrial cutting &amp; grinding wheels</p><span class="more">View Range &rarr;</span></a>
          <a class="brand-tile" href="{P}marksman.html"><img src="{P}images/marksman-logo.png" alt="Marksman logo" loading="lazy"><h3>Marksman</h3><p>Power tools &amp; accessories</p><span class="more">View Range &rarr;</span></a>
          <a class="brand-tile" href="{P}tailong.html"><img src="{P}images/tailong-logo.png" alt="Tailong logo" loading="lazy"><h3>Tailong</h3><p>Green-label abrasives &amp; cutting wheels</p><span class="more">View Range &rarr;</span></a>
        </div>
      </div>
    </section>

    <section class="section" style="padding-top:0">
      <div class="wrap">
$offerWhy
      </div>
    </section>

    <section class="section cta-band">
      <div class="wrap">
        <h2>Become a Dealer</h2>
        <p>We supply dealers across every major industrial cluster in India. Partner with us for reliable stock, honest pricing and same-day dispatch.</p>
        <div class="actions">
          <a class="btn btn-light" href="tel:+919811654647"><i class="fa-solid fa-phone"></i> Call Now</a>
          <a class="btn btn-whatsapp" href="$waDealer" target="_blank" rel="noopener"><i class="fa-brands fa-whatsapp"></i> WhatsApp Us</a>
        </div>
      </div>
    </section>

    <section class="section">
      <div class="wrap">
        <div class="section-head">
          <span class="eyebrow">Visit us</span>
          <h2>Our Office</h2>
        </div>
$officeBlock
      </div>
    </section>
"@
Page 'index.html' 'Shree Anurag Enterprises | Cutting Wheels, Grinding Wheels &amp; Power Tools' 'Home' $homeBody

# ---------- Product lines (one screen) ----------
$linesBody = @'
    <section class="lines-only">
      <div class="section-head">
        <span class="eyebrow">Our brands</span>
        <h2>View our Product Lines</h2>
        <p>Premium abrasives and power-tool solutions for every workshop.</p>
      </div>
      <div class="brand-grid">
        <a class="brand-card cormenflex" href="{P}cormenflex.html">
          <div class="logo-box"><img src="{P}images/cormenflex-logo.png" alt="Cormenflex logo"></div>
          <div class="body"><h3>Cormenflex</h3><p>Click here to see Gold-standard industrial cutting wheels</p></div>
        </a>
        <a class="brand-card marksman" href="{P}marksman.html">
          <div class="logo-box"><img src="{P}images/marksman-logo.png" alt="Marksman logo"></div>
          <div class="body"><h3>Marksman</h3><p>Click here to see Power tools &amp; accessories</p></div>
        </a>
        <a class="brand-card tailong" href="{P}tailong.html">
          <div class="logo-box"><img src="{P}images/tailong-logo.png" alt="Tailong logo"></div>
          <div class="body"><h3>Tailong</h3><p>Click here to see Green-label abrasives &amp; cutting wheels</p></div>
        </a>
      </div>
    </section>
'@
Page 'product-lines.html' 'Product Lines | Shree Anurag Enterprises' 'Brands' $linesBody 'single-screen'

# ---------- Listings ----------
Listing 'products.html'   'All Products'         'All Products' 'All Products' $products
Listing 'cormenflex.html' 'Cormenflex Catalogue' '<a href="{P}products.html">Products</a> / Cormenflex' 'Cormenflex' ($products | Where-Object { $_.brand -eq 'Cormenflex' })
Listing 'tailong.html'    'Tailong Catalogue'    '<a href="{P}products.html">Products</a> / Tailong'    'Tailong'    ($products | Where-Object { $_.brand -eq 'Tailong' })
Listing 'marksman.html'   'Marksman Catalogue'   '<a href="{P}products.html">Products</a> / Marksman'   'Marksman'   ($products | Where-Object { $_.brand -eq 'Marksman' }) `
  '        <p class="muted" style="margin-bottom:24px">Marksman power tools &amp; accessories &mdash; full range coming soon. Call or WhatsApp us for current availability.</p>'

# ---------- About ----------
$aboutBody = (Banner 'About Us' '<a href="{P}index.html">Home</a> / About') + @"

    <section class="section">
      <div class="wrap">
        <div class="text-panel">
          <h2>Our Story</h2>
          <p>Founded in 1996 by <strong>Anil Kumar Jain</strong>&mdash;and now run by his son <strong>Anurag Jain</strong>&mdash;Shree Anurag Enterprises has grown from a single-counter shop into one of India&rsquo;s most trusted suppliers of industrial abrasives and power-tool accessories.</p>
          <p>Three generations work together today, blending the personal touch of a neighbourhood business with the professionalism of a national distributor.</p>
          <p>We import and distribute premium cutting wheels, grinding wheels, abrasives and power-tools under the Marksman, Cormenflex &amp; Tailong brands.</p>
        </div>
      </div>
    </section>
    <section class="section" style="padding-top:0">
      <div class="wrap">
$offerWhy
      </div>
    </section>
"@
Page 'about.html' 'About Us | Shree Anurag Enterprises' 'About' $aboutBody

# ---------- Contact ----------
$contactBody = (Banner 'Contact Us' '<a href="{P}index.html">Home</a> / Contact') + @"

    <section class="section">
      <div class="wrap">
        <div class="section-head">
          <span class="eyebrow">We&rsquo;re here to help</span>
          <h2>Get in Touch</h2>
          <p>Same-day dispatch and technical guidance on call. Reach us by phone, WhatsApp or email.</p>
        </div>
$officeBlock
        <div style="display:flex;flex-wrap:wrap;gap:12px;justify-content:center;margin-top:32px">
          <a class="btn" href="tel:+919811654647"><i class="fa-solid fa-phone"></i> Call Now</a>
          <a class="btn btn-whatsapp" href="$waGeneral" target="_blank" rel="noopener"><i class="fa-brands fa-whatsapp"></i> WhatsApp Us</a>
          <a class="btn" href="https://maps.app.goo.gl/eKe1omaQVU8JVJix5" target="_blank" rel="noopener"><i class="fa-solid fa-map"></i> Open in Google Maps</a>
        </div>
      </div>
    </section>
"@
Page 'contact.html' 'Contact | Shree Anurag Enterprises' 'Contact' $contactBody

# ---------- Product detail pages (specs + description from the original product pages) ----------
foreach ($pr in $products) {
  $file = Join-Path $Src ('p_' + $pr.slug.Replace('/', '_') + '.html')
  $raw = [IO.File]::ReadAllText($file, [Text.Encoding]::UTF8)
  $specs = [regex]::Match($raw, '<table class="text-sm mb-6">(.*?)</table>', 'Singleline').Groups[1].Value
  $specs = [regex]::Replace($specs, '<tr><td[^>]*>slug</td><td>.*?</td></tr>', '')   # internal field, not for customers
  $specs = $specs -replace ' class="[^"]*"', ''
  $prose = [regex]::Match($raw, '<div class="prose[^"]*">(.*?)</div></article>', 'Singleline').Groups[1].Value
  $i = ImgFor $pr
  $plain = [Net.WebUtility]::HtmlDecode($pr.name)
  $wa = WaLink "Hello Shree Anurag Enterprises, I would like a quote for: $plain"
  $bp = $brandPage[$pr.brand]
  $body = (Banner $pr.name "<a href=`"{P}index.html`">Home</a> / <a href=`"{P}products.html`">Products</a> / <a href=`"{P}$bp`">$($pr.brand)</a>") + @"

    <section class="section">
      <div class="wrap">
        <a class="back-link" href="{P}$bp"><i class="fa-solid fa-arrow-left"></i> Back to $($pr.brand) Catalogue</a>
        <div class="detail">
          <div class="detail-img"><img src="{P}$($i[0])" alt="$($pr.name)"></div>
          <div class="detail-info">
            <h2>Specifications</h2>
            <table class="specs">$specs</table>
            <div class="prose">
$prose
            </div>
            <div class="detail-actions">
              <a class="btn btn-whatsapp" href="$wa" target="_blank" rel="noopener"><i class="fa-brands fa-whatsapp"></i> Enquire on WhatsApp</a>
              <a class="btn" href="tel:+919811654647"><i class="fa-solid fa-phone"></i> Call for Price</a>
            </div>
          </div>
        </div>
      </div>
    </section>
"@
  Page "products/$($pr.slug).html" "$($pr.name) | Shree Anurag Enterprises" 'Products' $body
}
