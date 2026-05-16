<template>
  <div class="min-h-screen bg-white font-sans selection:bg-red-100 selection:text-red-600 overflow-x-hidden">
    <!-- Navbar (Premium Redesign) -->
    <nav
      class="fixed top-0 left-0 w-full z-50 transition-all duration-500"
      :class="isScrolled
        ? 'bg-white/80 backdrop-blur-xl border-b border-slate-100/80 shadow-lg shadow-slate-900/5'
        : 'bg-transparent'">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 py-3 flex items-center justify-between">
        
        <!-- Logo -->
        <div class="flex items-center space-x-2.5 group cursor-pointer" @click="selectedBrand = null">
          <div
            class="relative w-9 h-9 bg-gradient-to-br from-red-500 to-red-700 rounded-xl flex items-center justify-center font-[1000] text-white italic text-sm shadow-lg transition-all duration-500 group-hover:shadow-red-500/40 group-hover:scale-110 group-hover:rotate-12"
            :class="isScrolled ? 'shadow-red-500/25' : 'shadow-red-500/40'">
            <span class="relative z-10">V</span>
            <div class="absolute inset-0 rounded-xl bg-white/10 opacity-0 group-hover:opacity-100 transition-opacity"></div>
          </div>
          <div class="relative">
            <h1
              class="text-xl font-[1000] tracking-tighter uppercase transition-colors duration-500"
              :class="isScrolled ? 'text-slate-900' : 'text-white'">
              VIP<span class="text-red-400">PHONE</span>
            </h1>
          </div>
        </div>

        <!-- Right Section -->
        <div
          class="flex items-center space-x-3 sm:space-x-5 text-[10px] sm:text-[11px] font-black uppercase tracking-[0.2em]">
          
          <!-- Desktop Nav Links -->
          <div class="hidden lg:flex items-center space-x-1">
            <a v-for="link in navLinks" :key="link.id" :href="link.href"
              class="relative px-3 py-2 rounded-lg text-[10px] font-black uppercase tracking-[0.25em] transition-all duration-300 group"
              :class="activeSection === link.id
                ? 'text-red-500'
                : isScrolled ? 'text-slate-400 hover:text-slate-900' : 'text-white/70 hover:text-white'">
              {{ link.label }}
              <span
                class="absolute bottom-1 left-3 right-3 h-0.5 rounded-full transition-transform duration-300 origin-left"
                :class="activeSection === link.id
                  ? 'bg-red-500 scale-x-100'
                  : 'bg-red-400 scale-x-0 group-hover:scale-x-100'">
              </span>
            </a>
          </div>

          <!-- Cart Button -->
          <button @click="isCartOpen = true"
            class="relative p-2 rounded-xl transition-all duration-300"
            :class="isScrolled
              ? 'text-slate-500 hover:text-red-600 hover:bg-red-50'
              : 'text-white/80 hover:text-white hover:bg-white/10'">
            <ShoppingBag class="w-4 h-4 sm:w-5 sm:h-5" />
            <span v-if="cartStore.cartCount > 0"
              class="absolute -top-0.5 -right-0.5 bg-gradient-to-br from-red-500 to-red-600 text-white text-[8px] font-black min-w-[16px] h-4 px-1 rounded-full flex items-center justify-center shadow-lg shadow-red-500/30 animate-cart-badge">
              {{ cartStore.cartCount }}
            </span>
          </button>
          
          <!-- User / Login -->
          <div v-if="authStore.user" class="flex items-center space-x-2">
            <div
              class="w-7 h-7 sm:w-8 sm:h-8 rounded-full bg-gradient-to-br from-red-400 to-red-600 flex items-center justify-center text-white text-[10px] font-black shadow-lg shadow-red-500/20">
              {{ authStore.user.email?.charAt(0).toUpperCase() || 'U' }}
            </div>
            <button @click="authStore.logout()"
              class="p-1.5 rounded-lg transition-all duration-300"
              :class="isScrolled
                ? 'text-slate-400 hover:text-red-500 hover:bg-red-50'
                : 'text-white/60 hover:text-white hover:bg-white/10'">
              <LogOut class="w-3.5 h-3.5 sm:w-4 sm:h-4" />
            </button>
          </div>
          <router-link v-else to="/login"
            class="relative px-4 py-2 rounded-full text-[9px] sm:text-[10px] font-black uppercase tracking-[0.25em] transition-all duration-300 overflow-hidden group active:scale-95"
            :class="isScrolled
              ? 'bg-slate-900 text-white hover:bg-red-600 shadow-lg shadow-slate-200'
              : 'bg-white/10 text-white hover:bg-white/20 backdrop-blur-sm border border-white/20'">
            <span class="relative z-10">เข้าสู่ระบบ</span>
          </router-link>

            <button @click="isMobileMenuOpen = !isMobileMenuOpen"
              class="lg:hidden relative w-8 h-8 rounded-xl transition-all duration-300 flex items-center justify-center"
              :class="isScrolled
                ? 'text-slate-600 hover:bg-slate-100'
                : 'text-white/80 hover:bg-white/10'">
              <div class="w-5 h-5 relative">
                <span
                  class="absolute block h-[2px] rounded-full transition-all duration-300 left-0 right-0"
                  :class="[
                    isMobileMenuOpen ? 'top-1/2 -translate-y-1/2 rotate-45' : 'top-0.5',
                    isScrolled ? 'bg-slate-600' : 'bg-white/80'
                  ]">
                </span>
                <span
                  class="absolute top-1/2 -translate-y-1/2 block h-[2px] rounded-full transition-all duration-300 left-0 right-0"
                  :class="[
                    isMobileMenuOpen ? 'opacity-0 scale-0' : '',
                    isScrolled ? 'bg-slate-600' : 'bg-white/80'
                  ]">
                </span>
                <span
                  class="absolute block h-[2px] rounded-full transition-all duration-300 left-0 right-0"
                  :class="[
                    isMobileMenuOpen ? 'top-1/2 -translate-y-1/2 -rotate-45' : 'bottom-0.5',
                    isScrolled ? 'bg-slate-600' : 'bg-white/80'
                  ]">
                </span>
              </div>
            </button>
        </div>
      </div>

      <!-- Mobile Menu Drawer -->
      <div
        class="lg:hidden fixed inset-x-0 top-[57px] bottom-0 transition-all duration-500 overflow-hidden"
        :class="isMobileMenuOpen ? 'pointer-events-auto' : 'pointer-events-none'">
        <!-- Backdrop -->
        <div
          class="absolute inset-0 bg-black/50 backdrop-blur-sm transition-opacity duration-500"
          :class="isMobileMenuOpen ? 'opacity-100' : 'opacity-0'"
          @click="isMobileMenuOpen = false">
        </div>
        <!-- Drawer Panel -->
        <div
          class="absolute top-0 left-0 right-0 bg-white rounded-b-3xl shadow-2xl shadow-slate-900/20 transition-all duration-500 overflow-hidden border-b border-slate-100"
          :class="isMobileMenuOpen ? 'translate-y-0 opacity-100' : '-translate-y-8 opacity-0'">
          <div class="px-6 py-6 space-y-1">
            <a v-for="link in navLinks" :key="link.id" :href="link.href"
              @click="isMobileMenuOpen = false"
              class="block px-4 py-3.5 rounded-xl text-sm font-bold text-slate-700 hover:text-red-600 hover:bg-red-50 transition-all duration-200"
              :class="activeSection === link.id ? 'text-red-600 bg-red-50' : ''">
              {{ link.label }}
            </a>
          </div>
        </div>
      </div>
    </nav>

    <!-- Hero Section (Premium Redesign) -->
    <header class="relative pt-28 pb-20 overflow-hidden min-h-[600px] flex items-center bg-black">
      <!-- Video Background Wrapper -->
      <div class="absolute inset-0 w-full h-full overflow-hidden">
        <video autoplay loop muted playsinline class="absolute inset-0 w-full h-full object-cover scale-105" style="filter: brightness(0.45) saturate(1.1);">
          <source src="/landingpage.mp4" type="video/mp4">
        </video>
        <!-- Cinematic Gradient Overlay Layers -->
        <div class="absolute inset-0 bg-gradient-to-t from-black/90 via-black/30 to-transparent"></div>
        <div class="absolute inset-0 bg-gradient-to-r from-black/40 via-transparent to-black/40"></div>
        <div class="absolute inset-0 bg-gradient-to-b from-black/20 via-transparent to-black/60"></div>
      </div>

      <!-- Animated Floating Orbs -->
      <div class="absolute inset-0 overflow-hidden pointer-events-none" style="z-index: 5;">
        <!-- Large glow orb top-right -->
        <div class="absolute -top-40 -right-40 w-[500px] h-[500px] rounded-full opacity-20 animate-pulse-slow"
          style="background: radial-gradient(circle, #EF4444 0%, transparent 70%);"></div>
        <!-- Small glow orb bottom-left -->
        <div class="absolute -bottom-20 -left-20 w-[300px] h-[300px] rounded-full opacity-15 animate-pulse-slow-delayed"
          style="background: radial-gradient(circle, #DC2626 0%, transparent 70%);"></div>
        <!-- Mid glow orb center -->
        <div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[600px] h-[600px] rounded-full opacity-10 animate-pulse-very-slow"
          style="background: radial-gradient(circle, #F87171 0%, transparent 70%);"></div>
      </div>

      <!-- Floating Glass Elements -->
      <div class="absolute inset-0 overflow-hidden pointer-events-none" style="z-index: 6;">
        <div class="floating-element absolute top-[20%] right-[10%] w-20 h-20 rounded-2xl border border-white/10 backdrop-blur-xl bg-white/5"></div>
        <div class="floating-element-delayed absolute bottom-[25%] left-[8%] w-14 h-14 rounded-full border border-white/10 backdrop-blur-xl bg-white/5"></div>
        <div class="floating-element-slow absolute top-[60%] right-[15%] w-10 h-10 rounded-full bg-red-500/10 backdrop-blur-sm border border-red-400/20"></div>
        <div class="floating-element-delayed absolute top-[15%] left-[12%] w-16 h-16 rounded-2xl border border-white/10 backdrop-blur-xl bg-white/5"></div>
      </div>

      <!-- Grid Pattern Overlay -->
      <div class="absolute inset-0 opacity-[0.03]" style="z-index: 4; background-image: linear-gradient(rgba(255,255,255,0.1) 1px, transparent 1px), linear-gradient(90deg, rgba(255,255,255,0.1) 1px, transparent 1px); background-size: 60px 60px;"></div>        <div class="max-w-7xl mx-auto px-6 text-center relative" style="z-index: 10;">
        <!-- Premium Badge -->
        <div class="mb-5 animate-fade-in-up">
          <span
            class="relative inline-flex items-center gap-2 px-3 py-1.5 bg-white/5 backdrop-blur-2xl border border-white/10 text-red-300 text-[8px] sm:text-[9px] font-black uppercase tracking-[0.35em] rounded-full shadow-2xl">
            <span class="relative flex w-1.5 h-1.5">
              <span class="animate-ping absolute inline-flex w-full h-full rounded-full bg-red-400 opacity-75"></span>
              <span class="relative inline-flex w-1.5 h-1.5 rounded-full bg-red-500"></span>
            </span>
            PREMIUM CERTIFIED DEALER
            <span class="w-px h-3 bg-white/20"></span>
            <span class="text-yellow-400 tracking-normal text-[10px]">★</span>
          </span>
        </div>

        <!-- Main Headline -->
        <h2
          class="text-5xl sm:text-6xl md:text-7xl lg:text-8xl font-[1000] text-white leading-none tracking-[-0.06em] mb-3 animate-fade-in-up relative">
          <span class="block">VIP</span>
          <span
            class="block text-transparent bg-clip-text bg-gradient-to-r from-red-400 via-red-500 to-red-600 drop-shadow-[0_0_25px_rgba(239,68,68,0.3)]">
            PHONE
          </span>
        </h2>

        <!-- Animated divider line -->
        <div class="flex items-center justify-center gap-2 mb-5 animate-fade-in-up delay-200">
          <div class="h-px w-10 bg-gradient-to-r from-transparent via-red-400 to-transparent"></div>
          <div class="w-1 h-1 rounded-full bg-red-500 shadow-lg shadow-red-500/50"></div>
          <div class="h-px w-10 bg-gradient-to-r from-transparent via-red-400 to-transparent"></div>
        </div>

        <!-- Subtitle -->
        <p
          class="text-sm sm:text-base md:text-lg text-white/80 font-bold max-w-3xl mx-auto mb-6 leading-relaxed animate-fade-in-up delay-300">
          <span class="inline-block bg-gradient-to-r from-white/90 via-red-200 to-white/90 bg-clip-text text-transparent">
            ยกระดับสมาร์ทโฟนมือสองสู่มาตรฐานใหม่
          </span>
          <br />
          <span class="text-white/60 font-medium text-xs sm:text-sm">
            ทุกเครื่องคือความสมบูรณ์แบบที่ผ่านการคัดสรรโดยผู้เชี่ยวชาญ
          </span>
        </p>

        <!-- CTA Buttons -->
        <div class="flex flex-col sm:flex-row items-center justify-center gap-3 animate-fade-in-up delay-500">
          <a href="#deals"
            class="group relative px-8 py-3 bg-white text-black rounded-full text-[10px] font-black uppercase tracking-[0.25em] transition-all duration-300 overflow-hidden shadow-2xl shadow-red-500/20">
            <span class="relative z-10 group-hover:text-white transition-colors duration-300">เลือกซื้อสินค้า</span>
            <div class="absolute inset-0 bg-gradient-to-r from-red-500 to-red-600 translate-y-full group-hover:translate-y-0 transition-transform duration-300 rounded-full"></div>
          </a>
          <a href="#quality"
            class="group px-8 py-3 border border-white/20 text-white/80 hover:text-white rounded-full text-[10px] font-black uppercase tracking-[0.25em] transition-all duration-300 hover:border-white/40 hover:bg-white/5 backdrop-blur-sm">
            ดูมาตรฐานเรา
          </a>
        </div>

        <!-- Trust Indicators -->
        <div ref="trustObserver" class="mt-10 flex flex-wrap items-center justify-center gap-6 sm:gap-10 animate-fade-in-up delay-700">
          <div class="text-center">
            <p class="text-xl sm:text-2xl font-black text-white drop-shadow-lg">{{ trustCount1 }}+</p>
            <p class="text-[8px] font-bold text-white/40 uppercase tracking-[0.2em] mt-1">เครื่องที่ขายแล้ว</p>
          </div>
          <div class="w-px h-8 bg-white/10"></div>
          <div class="text-center">
            <p class="text-xl sm:text-2xl font-black text-white drop-shadow-lg">{{ trustCount2 }}%</p>
            <p class="text-[8px] font-bold text-white/40 uppercase tracking-[0.2em] mt-1">ลูกค้าพึงพอใจ</p>
          </div>
          <div class="w-px h-8 bg-white/10"></div>
          <div class="text-center">
            <p class="text-xl sm:text-2xl font-black text-white drop-shadow-lg">{{ trustCount3 }}</p>
            <p class="text-[8px] font-bold text-white/40 uppercase tracking-[0.2em] mt-1">วันรับประกัน</p>
          </div>
        </div>

        <!-- Animated Scroll Indicator -->
        <div class="absolute bottom-6 left-1/2 -translate-x-1/2 animate-bounce-slow">
          <div class="w-5 h-8 rounded-full border-2 border-white/15 flex items-start justify-center pt-1.5">
            <div class="w-0.5 h-2.5 bg-red-400/70 rounded-full animate-scroll-dot"></div>
          </div>
        </div>
      </div>
    </header>


    <!-- Main Content -->
    <main class="max-w-7xl mx-auto px-6 py-12 md:py-24 space-y-24 md:space-y-32">

      <!-- Shop by Brand Section -->
      <section id="brands" class="section-animate" v-intersection>
        <h2 class="text-2xl font-bold text-slate-900 mb-8 md:mb-12 tracking-tight">เลือกตามแบรนด์</h2>
        <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-4">
          <div v-for="brand in brandOptions" :key="brand.name"
            @click="selectedBrand = (brand.name === 'ทั้งหมด' ? null : brand.name)"
            class="group bg-white border border-slate-100 rounded-2xl p-6 flex flex-col items-center justify-center hover:border-red-400 hover:shadow-lg transition-all duration-500 cursor-pointer h-36 hover-reveal"
            :class="(selectedBrand === brand.name || (selectedBrand === null && brand.name === 'ทั้งหมด')) ? 'border-red-600 shadow-lg shadow-red-100/50' : ''">
            <div class="h-12 flex items-center justify-center mb-5">
              <img v-if="brand.imageUrl" :src="brand.imageUrl" :alt="brand.name" loading="lazy"
                class="w-10 h-10 object-contain scale-110 group-hover:scale-125 transition-transform duration-500 opacity-90 group-hover:opacity-100" />
              <component v-else :is="brand.icon"
                class="text-slate-900 scale-110 group-hover:scale-125 transition-transform duration-500 w-10 h-10" />
            </div>
            <span
              class="text-[10px] font-black text-slate-400 uppercase tracking-[0.2em] group-hover:text-red-600 transition-colors"
              :class="(selectedBrand === brand.name || (selectedBrand === null && brand.name === 'ทั้งหมด')) ? 'text-red-600' : ''">{{
                brand.name }}</span>
          </div>
        </div>
      </section>

      <!-- Featured Deals Section -->
      <section id="deals" class="section-animate" v-intersection>
        <div class="relative z-10 p-8 lg:p-10 bg-white/10 backdrop-blur-[1px]">
          <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-8">
            <div>
              <p class="text-[10px] font-[1000] text-red-700 uppercase tracking-[0.3em] mb-1.5">MARKET WATCH</p>
              <h2 class="text-3xl font-bold text-slate-900 tracking-tight leading-none">Featured Deals</h2>
            </div>
            <div class="flex items-center gap-3">
              <div class="relative group">
                <Search class="absolute left-3 top-1/2 -translate-y-1/2 w-3.5 h-3.5 text-slate-400 group-focus-within:text-red-600 transition-colors pointer-events-none" />
                <input
                  v-model="searchQuery"
                  type="text"
                  placeholder="ค้นหาสินค้า..."
                  class="pl-9 pr-4 py-2.5 text-[11px] font-semibold bg-slate-50 border border-slate-200 rounded-xl w-52 focus:outline-none focus:border-red-400 focus:bg-white focus:shadow-md focus:shadow-red-100/50 transition-all placeholder:text-slate-300"
                />
                <button
                  v-if="searchQuery"
                  @click="searchQuery = ''"
                  class="absolute right-2.5 top-1/2 -translate-y-1/2 text-slate-300 hover:text-slate-600 transition-colors"
                >
                  <X class="w-3 h-3" />
                </button>
              </div>
              <button v-if="selectedBrand" @click="selectedBrand = null"
                class="text-[10px] font-black text-slate-300 hover:text-red-600 transition-colors uppercase tracking-widest whitespace-nowrap">
                ล้างการเลือก
              </button>
            </div>
          </div>

          <div v-if="loading" class="grid grid-cols-2 lg:grid-cols-4 gap-4">
            <Skeleton v-for="i in 8" :key="i" class="aspect-[3/4] w-full" />
          </div>

          <div v-else-if="filteredProducts.length === 0"
            class="py-24 text-center border-2 border-dashed border-slate-100 rounded-3xl bg-white/50 backdrop-blur-md">
            <Smartphone class="w-12 h-12 text-slate-200 mx-auto mb-4" />
            <p class="text-slate-400 font-bold uppercase tracking-widest text-xs">ไม่พบสินค้าในขณะนี้</p>
          </div>

          <div v-else class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
            <div v-for="product in displayedProducts" :key="product.id"
              class="group bg-white/90 border border-slate-100 rounded-lg p-4 hover:shadow-xl hover:bg-white transition-all duration-500 hover-reveal">
              <div class="relative aspect-square rounded-md overflow-hidden mb-6 flex items-center justify-center">
                <img v-if="product.thumbnail" :src="assetUrl(product.thumbnail)" loading="lazy"
                  class="w-full h-full object-contain p-2 transition-transform duration-700 group-hover:scale-110" />
                <div v-else class="w-full h-full flex items-center justify-center">
                  <Smartphone class="w-12 h-12 text-slate-200" />
                </div>
                <div class="absolute top-2 left-2">
                  <span v-if="product.condition === 'new'"
                    class="bg-[#EF4444] text-white text-[8px] font-black px-2 py-0.5 rounded-sm uppercase tracking-wider shadow-sm">HOT</span>
                  <span v-else
                    class="bg-[#DC2626] text-white text-[8px] font-black px-2 py-0.5 rounded-sm uppercase tracking-wider shadow-sm">SALE
                    -15%</span>
                </div>
              </div>

              <div class="relative">
                <div class="absolute top-0 right-0">
                  <span :class="getConditionClass(product.batteryHealth)"
                    class="text-[8px] font-[1000] px-1.5 py-0.5 rounded-sm border uppercase tracking-wider bg-white">
                    {{ getConditionLabel(product.batteryHealth) }}
                  </span>
                </div>

                <h3 class="text-[15px] font-bold text-slate-900 mb-1 leading-tight">{{ product.model }}</h3>
                <p class="text-[10px] text-slate-400 font-bold mb-4 uppercase tracking-tighter">
                  {{ product.storage }} | {{ product.color }} | unlocked
                </p>

                <div class="flex items-baseline space-x-3 mb-6">
                  <span class="text-xl font-bold text-slate-900">฿{{ Number(product.sellPrice).toLocaleString()
                  }}</span>
                  <span v-if="product.condition !== 'new'" class="text-sm text-slate-300 font-bold line-through">฿{{
                    Number(product.sellPrice * 1.15).toLocaleString() }}</span>
                </div>

                <button @click="addToCart(product)"
                  class="w-full bg-black text-white py-3 rounded-md text-[10px] font-black uppercase tracking-[0.2em] hover:bg-red-600 transition-all active:scale-[0.98]">
                  เพิ่มลงตะกร้า
                </button>
              </div>
            </div>
          </div>

          <div v-if="filteredProducts.length > 8" class="mt-16 text-center">
            <button @click="showAll = !showAll"
              class="px-12 py-3.5 border-2 border-slate-900 text-slate-900 font-black text-[10px] uppercase tracking-[0.3em] rounded-xl hover:bg-black hover:text-white backdrop-blur-md transition-all active:scale-95 shadow-xl shadow-slate-100">
              {{ showAll ? 'แสดงน้อยลง' : 'แสดงทั้งหมด' }}
            </button>
          </div>
        </div>
      </section>

      <!-- ... (Rest of content) -->

      <!-- Quality Assurance Section (Compact) -->
      <section id="quality" class="section-animate" v-intersection>
        <div class="grid lg:grid-cols-2 gap-12 items-center border-t border-slate-100 pt-20">
          <div class="bg-black text-white p-10 lg:p-16 rounded-[3rem] relative overflow-hidden">
            <div class="absolute top-0 right-0 w-64 h-64 bg-red-600/20 rounded-full blur-[80px]"></div>
            <span class="text-[9px] font-black text-red-400 uppercase tracking-[0.5em] mb-8 block">DIAGNOSTIC
              EXCELLENCE</span>
            <h2 class="text-4xl lg:text-5xl font-[1000] mb-10 leading-none tracking-tighter">
              BEYOND <br />
              INSPECTION.
            </h2>
            <div class="space-y-6">
              <div v-for="item in [
                { title: 'หน้าจอและระบบสัมผัส', desc: 'ตรวจสอบพิกเซลและความลื่นไหล 100%' },
                { title: 'สุขภาพแบตเตอรี่', desc: 'ยืนยันความจุจริงและรอบการชาร์จ' },
                { title: 'เครือข่ายและการเชื่อมต่อ', desc: 'ทดสอบ 5G, WiFi และ Bluetooth เต็มรูปแบบ' }
              ]" :key="item.title" class="flex items-start space-x-4">
                <div class="w-5 h-5 rounded-full bg-red-500 flex items-center justify-center mt-1 shrink-0">
                  <Check class="w-3 h-3 text-white" />
                </div>
                <div>
                  <h4 class="text-xs font-black uppercase tracking-widest text-white">{{ item.title }}</h4>
                  <p class="text-slate-500 text-[10px] mt-1">{{ item.desc }}</p>
                </div>
              </div>
            </div>
          </div>
          <div>
            <h2 class="text-4xl font-black text-slate-900 tracking-tighter leading-tight mb-6 h-32">
              <span class="typing-text">{{ typedText }}</span>
              <span class="cursor">|</span>
            </h2>
            <p class="text-base text-slate-500 font-medium leading-relaxed mb-10">
              เรายึดถือมาตรฐานสูงสุดในการส่งมอบสมาร์ทโฟนมือสองคุณภาพดีเยี่ยม
              เพื่อให้คุณมั่นใจว่าทุกการใช้งานจะเป็นไปอย่างปลอดภัยไร้กังวล
            </p>
            <div class="grid grid-cols-2 gap-6">
              <div class="p-6 bg-slate-50 rounded-2xl border border-slate-100">
                <p class="text-4xl font-black text-slate-900 mb-1 leading-none tracking-tighter text-red-600">100%</p>
                <p class="text-[9px] font-black text-slate-400 uppercase tracking-widest">อะไหล่แท้แน่นอน</p>
              </div>
              <div class="p-6 bg-slate-50 rounded-2xl border border-slate-100">
                <p class="text-4xl font-black text-slate-900 mb-1 leading-none tracking-tighter text-red-600">30</p>
                <p class="text-[9px] font-black text-slate-400 uppercase tracking-widest">วัน การรับประกัน</p>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- FAQ Section (Accordion) -->
      <section id="faq" class="section-animate py-16 md:py-20" v-intersection>
        <div class="text-center mb-10 md:mb-14 faq-header">
          <span class="inline-block text-[9px] font-black text-red-600 uppercase tracking-[0.4em] mb-3">FAQ</span>
          <h2 class="text-3xl md:text-4xl font-bold text-slate-900 tracking-tight">
            คำถาม<span class="text-red-600">ที่พบบ่อย</span>
          </h2>
          <p class="text-sm text-slate-400 mt-3 max-w-xl mx-auto">
            รวมคำถามที่ลูกค้ามักสอบถาม เราพร้อมให้ข้อมูลอย่างชัดเจน
          </p>
        </div>
        <div class="max-w-3xl mx-auto space-y-3">
          <div v-for="(item, i) in faqItems" :key="i"
            class="faq-item group rounded-2xl border transition-all duration-300 cursor-pointer overflow-hidden"
            :class="activeFaq === i
              ? 'border-red-200 bg-white shadow-lg shadow-red-100/30'
              : 'border-slate-100 bg-[#F8FAFC] hover:border-slate-200 hover:bg-white hover:shadow-sm'">
            
            <!-- Question Header -->
            <button @click="toggleFaq(i)"
              class="w-full flex items-center justify-between gap-4 px-5 py-4 md:px-6 md:py-5 text-left">
              <div class="flex items-center gap-3 min-w-0">
                <div
                  class="w-7 h-7 rounded-lg flex items-center justify-center shrink-0 transition-all duration-300"
                  :class="activeFaq === i
                    ? 'bg-red-600 text-white shadow-sm shadow-red-200'
                    : 'bg-red-50 text-red-500 group-hover:bg-red-100'">
                  <span class="text-[11px] font-black">{{ i + 1 }}</span>
                </div>
                <h4
                  class="text-sm md:text-base font-bold transition-colors duration-300"
                  :class="activeFaq === i ? 'text-slate-900' : 'text-slate-700 group-hover:text-slate-900'">
                  {{ item.q }}
                </h4>
              </div>
              <ChevronDown
                class="w-4 h-4 shrink-0 transition-all duration-300"
                :class="activeFaq === i
                  ? 'rotate-180 text-red-600'
                  : 'text-slate-300 group-hover:text-slate-500'" />
            </button>

            <!-- Answer Collapse -->
            <div
              class="accordion-collapse"
              :class="activeFaq === i ? 'accordion-open' : ''">
              <div class="px-5 pb-4 md:px-6 md:pb-5">
                <div class="pl-10 border-l-2 border-red-100">
                  <p class="text-sm text-slate-500 leading-relaxed">
                    {{ item.a }}
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- CTA -->
        <div class="text-center mt-10 faq-cta">
          <p class="text-xs text-slate-400 mb-4">ยังมีข้อสงสัย? ทีมของเราพร้อมช่วยเหลือคุณ</p>
          <a href="#"
            class="inline-flex items-center gap-2 px-6 py-3 bg-slate-900 text-white rounded-full text-[10px] font-black uppercase tracking-[0.2em] hover:bg-red-600 transition-all duration-300 active:scale-95 shadow-lg shadow-slate-200">
            ติดต่อเรา
            <ArrowRight class="w-3.5 h-3.5" />
          </a>
        </div>
      </section>

    </main>

    <!-- Footer (Premium Redesign) -->
    <footer class="bg-black text-white overflow-hidden relative">
      <!-- Background glow effects -->
      <div class="absolute inset-0 overflow-hidden pointer-events-none">
        <div class="absolute -top-40 -right-40 w-[600px] h-[600px] rounded-full opacity-[0.08]"
          style="background: radial-gradient(circle, #3B82F6 0%, transparent 70%);"></div>
        <div class="absolute -bottom-40 -left-40 w-[500px] h-[500px] rounded-full opacity-[0.05]"
          style="background: radial-gradient(circle, #8B5CF6 0%, transparent 70%);"></div>
      </div>
      <!-- Grid pattern -->
      <div class="absolute inset-0 opacity-[0.02]" style="background-image: linear-gradient(rgba(255,255,255,0.05) 1px, transparent 1px), linear-gradient(90deg, rgba(255,255,255,0.05) 1px, transparent 1px); background-size: 60px 60px;"></div>

      <!-- Watermark text -->
      <div
        class="absolute bottom-0 left-1/2 -translate-x-1/2 text-[12vw] sm:text-[10vw] font-[1000] text-white/[0.02] whitespace-nowrap pointer-events-none tracking-tighter select-none leading-none">
        VIP PHONE</div>

      <div class="max-w-7xl mx-auto px-6 relative z-10">
        <!-- Main Footer Content -->
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-10 lg:gap-12 pt-16 pb-12 border-b border-white/10">

          <!-- Brand Column -->
          <div class="lg:col-span-1">
            <div class="flex items-center space-x-2.5 mb-5">
              <div
                class="w-9 h-9 bg-gradient-to-br from-red-500 to-red-700 rounded-xl flex items-center justify-center font-[1000] text-white italic text-sm shadow-lg shadow-red-500/20">
                V</div>
              <h3 class="text-xl font-[1000] tracking-tighter uppercase">VIP<span class="text-red-400">PHONE</span></h3>
            </div>
            <p class="text-sm text-slate-400 leading-relaxed mb-6">
              ผู้เชี่ยวชาญด้านสมาร์ทโฟนมือสองคุณภาพสูง ทุกเครื่องผ่านการตรวจสอบโดยผู้ชำนาญการ ก่อนถึงมือคุณ
            </p>
            <!-- Social Links -->
            <div class="flex items-center space-x-3">
              <a href="#"
                class="w-9 h-9 rounded-xl bg-white/5 border border-white/10 flex items-center justify-center text-slate-400 hover:bg-red-500 hover:text-white hover:border-red-500 transition-all duration-300 group">
                <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 24 24"><path d="M22 12c0-5.523-4.477-10-10-10S2 6.477 2 12c0 4.991 3.657 9.128 8.438 9.878v-6.987h-2.54V12h2.54V9.797c0-2.506 1.492-3.89 3.777-3.89 1.094 0 2.238.195 2.238.195v2.46h-1.26c-1.243 0-1.63.771-1.63 1.562V12h2.773l-.443 2.89h-2.33v6.988C18.343 21.128 22 16.991 22 12z"/></svg>
              </a>
              <a href="#"
                class="w-9 h-9 rounded-xl bg-white/5 border border-white/10 flex items-center justify-center text-slate-400 hover:bg-red-500 hover:text-white hover:border-red-500 transition-all duration-300">
                <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 24 24"><path d="M8.29 20.251c7.547 0 11.675-6.253 11.675-11.675 0-.178 0-.355-.012-.53A8.348 8.348 0 0022 5.92a8.19 8.19 0 01-2.357.646 4.118 4.118 0 001.804-2.27 8.224 8.224 0 01-2.605.996 4.107 4.107 0 00-6.993 3.743 11.65 11.65 0 01-8.457-4.287 4.106 4.106 0 001.27 5.477A4.072 4.072 0 012.8 9.713v.052a4.105 4.105 0 003.292 4.022 4.095 4.095 0 01-1.853.07 4.108 4.108 0 003.834 2.85A8.233 8.233 0 012 18.407a11.616 11.616 0 006.29 1.84"/></svg>
              </a>
              <a href="#"
                class="w-9 h-9 rounded-xl bg-white/5 border border-white/10 flex items-center justify-center text-slate-400 hover:bg-red-500 hover:text-white hover:border-red-500 transition-all duration-300">
                <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 24 24"><path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zM12 0C8.741 0 8.333.014 7.053.072 2.695.272.273 2.69.073 7.052.014 8.333 0 8.741 0 12c0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98C8.333 23.986 8.741 24 12 24c3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98C15.668.014 15.259 0 12 0zm0 5.838a6.162 6.162 0 100 12.324 6.162 6.162 0 000-12.324zM12 16a4 4 0 110-8 4 4 0 010 8zm6.406-11.845a1.44 1.44 0 100 2.881 1.44 1.44 0 000-2.881z"/></svg>
              </a>
              <a href="#"
                class="w-9 h-9 rounded-xl bg-white/5 border border-white/10 flex items-center justify-center text-slate-400 hover:bg-red-500 hover:text-white hover:border-red-500 transition-all duration-300">
                <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 24 24"><path d="M18.77 7.46H14.5v-1.9c0-.9.6-1.1 1-1.1h3V.5h-4.33C10.24.5 9.35 3.24 9.35 5.47v1.99H6.73v3.91h2.62V23.5h4.15V11.38h2.98l.29-3.92z"/></svg>
              </a>
            </div>
          </div>

          <!-- Quick Links -->
          <div>
            <h4 class="text-[10px] font-black text-red-400 uppercase tracking-[0.3em] mb-5">ลิงก์</h4>
            <ul class="space-y-3.5">
              <li v-for="link in footerQuickLinks" :key="link.label">
                <a :href="link.href"
                  class="text-sm text-slate-400 hover:text-white transition-all duration-300 flex items-center group">
                  <span class="w-1 h-1 rounded-full bg-red-500 opacity-0 group-hover:opacity-100 mr-2.5 transition-opacity"></span>
                  {{ link.label }}
                </a>
              </li>
            </ul>
          </div>

          <!-- Support -->
          <div>
            <h4 class="text-[10px] font-black text-red-400 uppercase tracking-[0.3em] mb-5">ช่วยเหลือ</h4>
            <ul class="space-y-3.5">
              <li v-for="link in footerSupportLinks" :key="link.label">
                <a :href="link.href"
                  class="text-sm text-slate-400 hover:text-white transition-all duration-300 flex items-center group">
                  <span class="w-1 h-1 rounded-full bg-red-500 opacity-0 group-hover:opacity-100 mr-2.5 transition-opacity"></span>
                  {{ link.label }}
                </a>
              </li>
            </ul>
          </div>

          <!-- Contact -->
          <div>
            <h4 class="text-[10px] font-black text-red-400 uppercase tracking-[0.3em] mb-5">ติดต่อ</h4>
            <ul class="space-y-4">
              <li class="flex items-start space-x-3">
                <MapPin class="w-4 h-4 text-red-400 mt-0.5 shrink-0" />
                <span class="text-sm text-slate-400">88/1 ถนนสุขุมวิท แขวงคลองเตย<br/>เขตคลองเตย กรุงเทพฯ 10110</span>
              </li>
              <li class="flex items-center space-x-3">
                <Phone class="w-4 h-4 text-red-400 shrink-0" />
                <a href="tel:+6621234567" class="text-sm text-slate-400 hover:text-white transition-colors">02-123-4567</a>
              </li>
              <li class="flex items-center space-x-3">
                <Mail class="w-4 h-4 text-red-400 shrink-0" />
                <a href="mailto:contact@vipphone.com" class="text-sm text-slate-400 hover:text-white transition-colors">contact@vipphone.com</a>
              </li>
              <li class="flex items-center space-x-3">
                <Clock class="w-4 h-4 text-red-400 shrink-0" />
                <span class="text-sm text-slate-400">จ.-ส. 09:00 - 18:00 น.</span>
              </li>
            </ul>
          </div>

        </div>

        <!-- Bottom Bar -->
        <div class="flex flex-col sm:flex-row items-center justify-between gap-4 py-8">
          <p class="text-[10px] font-bold text-slate-600 uppercase tracking-[0.3em]">
            &copy; 2026 VIP Phone. สงวนลิขสิทธิ์ตามกฎหมาย
          </p>
          <div class="flex items-center space-x-6">
            <a href="#" class="text-[9px] font-bold text-slate-600 hover:text-slate-400 uppercase tracking-[0.2em] transition-colors">นโยบายความเป็นส่วนตัว</a>
            <a href="#" class="text-[9px] font-bold text-slate-600 hover:text-slate-400 uppercase tracking-[0.2em] transition-colors">ข้อกำหนดการใช้งาน</a>
          </div>
        </div>
      </div>
    </footer>
    <CartModal :isOpen="isCartOpen" @close="isCartOpen = false" />

    <!-- Chatbot Widget -->
    <div class="fixed bottom-0 sm:bottom-6 left-0 sm:left-auto right-0 sm:right-6 z-50 sm:flex sm:items-end sm:justify-end">
      <!-- Chat Bubble Button (Desktop only when chat closed) -->
      <button v-if="!isChatOpen" @click="openChat"
        class="hidden sm:flex w-14 h-14 rounded-full bg-gradient-to-br from-red-500 to-red-700 text-white shadow-xl shadow-red-500/30 hover:shadow-red-500/50 hover:scale-105 transition-all duration-300 items-center justify-center group relative">
        <MessageCircle class="w-6 h-6 group-hover:scale-110 transition-transform" />
        <!-- Notification dot -->
        <span class="absolute -top-1 -right-1 w-4 h-4 bg-red-500 rounded-full border-2 border-white flex items-center justify-center">
          <span class="text-[7px] font-black">1</span>
        </span>
      </button>

      <!-- Mobile Quick Button (shown on mobile only) -->
      <button v-if="!isChatOpen" @click="openChat"
        class="flex sm:hidden fixed bottom-6 right-6 w-14 h-14 rounded-full bg-gradient-to-br from-red-500 to-red-700 text-white shadow-xl shadow-red-500/30 hover:scale-105 active:scale-95 transition-all duration-300 items-center justify-center group">
        <MessageCircle class="w-6 h-6" />
        <span class="absolute -top-1 -right-1 w-4 h-4 bg-red-500 rounded-full border-2 border-white flex items-center justify-center">
          <span class="text-[7px] font-black">1</span>
        </span>
      </button>

      <!-- Chat Window -->
      <div v-if="isChatOpen"
        class="chat-window bg-white shadow-2xl shadow-slate-900/20 border border-slate-100 flex flex-col overflow-hidden
          w-full sm:w-[380px]
          h-full sm:h-[560px]
          rounded-t-2xl sm:rounded-2xl
          border-b-0 sm:border-b">
        
        <!-- Header -->
        <div class="bg-gradient-to-r from-red-600 to-red-700 px-4 py-3.5 flex items-center justify-between shrink-0">
          <div class="flex items-center space-x-3">
            <div class="w-8 h-8 bg-white/20 rounded-xl flex items-center justify-center">
              <Bot class="w-4 h-4 text-white" />
            </div>
            <div>
              <h4 class="text-sm font-bold text-white">VIP Phone</h4>
              <p class="text-[10px] text-red-200">ออนไลน์</p>
            </div>
          </div>
          <button @click="closeChat"
            class="w-7 h-7 rounded-lg bg-white/10 hover:bg-white/20 flex items-center justify-center transition-colors">
            <X class="w-3.5 h-3.5 text-white" />
          </button>
        </div>

        <!-- Messages -->
        <div ref="chatMessagesRef" class="flex-1 overflow-y-auto p-4 space-y-3 bg-slate-50/50" style="scroll-behavior: smooth;">
          <div v-for="(msg, i) in chatMessages" :key="i"
            class="flex"
            :class="msg.isUser ? 'justify-end' : 'justify-start'">
            <!-- Bot avatar -->
            <div v-if="!msg.isUser" class="w-7 h-7 rounded-xl bg-gradient-to-br from-red-500 to-red-600 flex items-center justify-center mr-2.5 mt-0.5 shrink-0">
              <Bot class="w-3.5 h-3.5 text-white" />
            </div>
            <div
              class="max-w-[85%] px-3.5 py-2.5 text-sm leading-relaxed shadow-sm"
              :class="msg.isUser
                ? 'bg-red-600 text-white rounded-2xl rounded-br-md'
                : 'bg-white text-slate-700 rounded-2xl rounded-bl-md border border-slate-100'">
              {{ msg.text }}
            </div>
          </div>
          <!-- Typing indicator -->
          <div v-if="isTyping" class="flex justify-start">
            <div class="w-7 h-7 rounded-xl bg-gradient-to-br from-red-500 to-red-600 flex items-center justify-center mr-2.5 mt-0.5 shrink-0">
              <Bot class="w-3.5 h-3.5 text-white" />
            </div>
            <div class="bg-white border border-slate-100 rounded-2xl rounded-bl-md px-4 py-3 shadow-sm">
              <div class="typing-dots flex items-center space-x-1">
                <span class="w-2 h-2 bg-red-400 rounded-full"></span>
                <span class="w-2 h-2 bg-red-400 rounded-full"></span>
                <span class="w-2 h-2 bg-red-400 rounded-full"></span>
              </div>
            </div>
          </div>
        </div>

        <!-- Quick Replies -->
        <div v-if="showQuickReplies" class="px-4 py-2.5 border-t border-slate-100 bg-white shrink-0">
          <div class="flex flex-wrap gap-1.5">
            <button v-for="(reply, i) in quickReplies" :key="i" @click="sendQuickReply(reply)"
              class="text-[10px] font-bold px-3 py-1.5 rounded-full border border-slate-200 bg-white text-slate-600 hover:border-red-300 hover:text-red-600 hover:shadow-sm active:scale-95 transition-all duration-200">
              {{ reply.text }}
            </button>
          </div>
        </div>

        <!-- Input -->
        <div class="px-4 py-3 border-t border-slate-100 bg-white shrink-0">
          <form @submit.prevent="sendMessage" class="flex items-center space-x-2">
            <input ref="chatInputRef" v-model="chatInput" type="text" placeholder="พิมพ์ข้อความ..."
              class="flex-1 text-sm bg-slate-50 border border-slate-200 rounded-xl px-3.5 py-2.5 focus:outline-none focus:border-red-400 focus:bg-white focus:ring-2 focus:ring-red-100 transition-all placeholder:text-slate-400" />
            <button type="submit" :disabled="!chatInput.trim()"
              class="w-9 h-9 rounded-xl bg-red-600 text-white flex items-center justify-center hover:bg-red-700 transition-colors disabled:opacity-40 disabled:cursor-not-allowed shrink-0">
              <Send class="w-4 h-4" />
            </button>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted, nextTick, defineComponent, h } from 'vue';
import axios from 'axios';
import { ShoppingBag, ArrowRight, MoreHorizontal, Check, Menu, LogOut, Search, X, MapPin, Phone, Mail, Clock, ChevronDown, MessageCircle, Send, Bot } from 'lucide-vue-next';
import { useCartStore } from '../store/cart';
import { useAuthStore } from '../store/auth';
import CartModal from '../components/CartModal.vue';
import Skeleton from '../components/Skeleton.vue';
import { useRouter } from 'vue-router';
import { getApiBasePath, assetUrl } from '../config/api';
import { useToast } from 'vue-toastification';

const isCartOpen = ref(false);
const cartStore = useCartStore();
const authStore = useAuthStore();
const toast = useToast();
const availableProducts = ref([]);
const loading = ref(true);
const selectedBrand = ref(null);
const showAll = ref(false);
const searchQuery = ref('');
const router = useRouter();

// ===== Navbar State =====
const isScrolled = ref(false);
const isMobileMenuOpen = ref(false);
const activeSection = ref('');

const navLinks = [
  { id: 'deals', href: '#deals', label: 'สินค้าแนะนำ' },
  { id: 'brands', href: '#brands', label: 'แบรนด์' },
  { id: 'quality', href: '#quality', label: 'คุณภาพ' },
  { id: 'faq', href: '#faq', label: 'คำถาม' },
];

const footerQuickLinks = [
  { href: '#deals', label: 'สินค้าแนะนำ' },
  { href: '#brands', label: 'แบรนด์' },
  { href: '#quality', label: 'มาตรฐานคุณภาพ' },
  { href: '#faq', label: 'คำถามที่พบบ่อย' },
  { href: '/register', label: 'สมัครสมาชิก' },
];

const footerSupportLinks = [
  { href: '#', label: 'การสั่งซื้อและชำระเงิน' },
  { href: '#', label: 'นโยบายการรับประกัน' },
  { href: '#', label: 'การจัดส่งและการคืนสินค้า' },
  { href: '#', label: 'ศูนย์บริการหลังการขาย' },
  { href: '#', label: 'คำแนะนำการใช้งาน' },
];

// ===== FAQ Accordion =====
const activeFaq = ref(null);
const faqItems = [
  {
    q: 'สินค้าของ VIP Phone รับประกันอย่างไร?',
    a: 'สินค้าทุกเครื่องรับประกันการใช้งาน 30 วันเต็ม หากพบปัญหาปกติ สามารถส่งเคลมได้ทันทีโดยไม่มีค่าใช้จ่าย พร้อมทีมช่างผู้เชี่ยวชาญคอยดูแลตลอดอายุการรับประกัน'
  },
  {
    q: 'สามารถขอดูสภาพเครื่องจริงก่อนสั่งซื้อได้ไหม?',
    a: 'ลูกค้าสามารถดูวิดีโอ 360 องศา และรูปถ่ายรายละเอียดทุกมุมของเครื่องได้ในหน้าสินค้า และสามารถนัดหมายเข้ามาดูสินค้าจริงที่ร้านได้ก่อนตัดสินใจ'
  },
  {
    q: 'มีบริการผ่อนชำระหรือเปล่า?',
    a: 'เรามีบริการผ่อนชำระ 0% นานสูงสุด 10 เดือน ผ่านบัตรเครดิตชั้นนำทุกธนาคาร พร้อมโปรโมชั่นพิเศษสำหรับลูกค้าที่ชำระเต็มจำนวน'
  },
  {
    q: 'จัดส่งสินค้าใช้เวลากี่วัน?',
    a: 'จัดส่งฟรีทั่วประเทศ ใช้เวลา 1-3 วันทำการ หลังการชำระเงินเรียบร้อย เราห่ออย่างดีด้วยวัสดุกันกระแทก พร้อมประกันการจัดส่งทุกคำสั่งซื้อ'
  },
  {
    q: 'สามารถเปลี่ยนหรือคืนสินค้าได้ไหม?',
    a: 'สามารถเปลี่ยนหรือคืนสินค้าได้ภายใน 7 วัน หลังจากได้รับสินค้า โดยเครื่องต้องอยู่ในสภาพสมบูรณ์ ไม่มีรอยเสียหายจากการใช้งาน และมีอุปกรณ์ครบชุด'
  },
];

const toggleFaq = (index) => {
  activeFaq.value = activeFaq.value === index ? null : index;
};

// ===== Chatbot =====
const isChatOpen = ref(false);
const chatInput = ref('');
const isTyping = ref(false);
const showQuickReplies = ref(true);
const chatMessagesRef = ref(null);
const chatInputRef = ref(null);

const quickReplies = [
  { text: '🏷️ ราคาสินค้า', keyword: 'ราคา' },
  { text: '📦 รับประกัน', keyword: 'รับประกัน' },
  { text: '🚚 จัดส่ง', keyword: 'จัดส่ง' },
  { text: '💳 ผ่อนชำระ', keyword: 'ผ่อน' },
];

const chatMessages = ref([
  { text: 'สวัสดีครับ 🙌 ยินดีต้อนรับสู่ VIP Phone! มีอะไรให้เราช่วยสอบถามได้เลยครับ', isUser: false },
]);

const chatResponses = {
  'สวัสดี': 'สวัสดีครับ 👋 มีอะไรให้เราช่วยแนะนำสินค้าหรือตอบคำถามเพิ่มเติมไหมครับ?',
  'ราคา': '💎 สินค้าของเราเริ่มต้นตั้งแต่ 5,990 - 45,900 บาท ขึ้นอยู่กับรุ่นและสภาพครับ\n\nลองเข้ามาดูสินค้าแนะนำของเราได้เลยที่ปุ่ม "เลือกซื้อสินค้า" บนหน้าเว็บ หรือบอกเราหน่อยว่าสนใจรุ่นไหนครับ?',
  'รับประกัน': '🛡️ ทุกเครื่องรับประกัน 30 วันเต็ม!\n\nหากพบปัญหาการใช้งาน สามารถส่งเคลมได้ทันทีโดยไม่มีค่าใช้จ่าย พร้อมทีมช่างผู้เชี่ยวชาญคอยดูแลตลอดอายุการรับประกัน\n\nนอกจากนี้ยังมีประกันเพิ่มเติมสูงสุด 1 ปีให้เลือกด้วยนะครับ',
  'จัดส่ง': '📦 จัดส่งฟรีทั่วประเทศ!\n\nใช้เวลา 1-3 วันทำการ หลังการชำระเงินเรียบร้อย เราห่ออย่างดีด้วยวัสดุกันกระแทก พร้อมประกันการจัดส่งทุกคำสั่งซื้อ\n\nหรือถ้าสะดวกก็สามารถมารับที่ร้านได้เลยครับ',
  'ผ่อน': '💳 มีบริการผ่อนชำระ 0% นานสูงสุด 10 เดือน\n\nผ่านบัตรเครดิตชั้นนำทุกธนาคาร พร้อมโปรโมชั่นพิเศษสำหรับลูกค้าที่ชำระเต็มจำนวน\n\nสนใจรุ่นไหนลองเช็คราคาดูได้เลยครับ!',
  'เปลี่ยน': '🔄 สามารถเปลี่ยนหรือคืนสินค้าได้ภายใน 7 วัน\n\nหลังจากได้รับสินค้า โดยเครื่องต้องอยู่ในสภาพสมบูรณ์ ไม่มีรอยเสียหายจากการใช้งาน และมีอุปกรณ์ครบชุด\n\nยินดีให้คำแนะนำเพิ่มเติมครับ',
  'default': 'ขอบคุณที่สอบถามนะครับ 🙏\n\nถ้าต้องการข้อมูลเพิ่มเติม สามารถเลือกหัวข้อด้านล่าง หรือพิมพ์คำถามมาได้เลยครับ\n\n📌 คำแนะนำ: ลองพิมพ์ คำว่าด้านล่างนี้ดูได้นะครับ\n• "ราคา" - ข้อมูลราคาสินค้า\n• "รับประกัน" - รายละเอียดการรับประกัน\n• "จัดส่ง" - ข้อมูลการจัดส่ง\n• "ผ่อน" - บริการผ่อนชำระ\n• "เปลี่ยน" - นโยบายเปลี่ยนคืน',
};

const scrollChatToBottom = async () => {
  await nextTick();
  if (chatMessagesRef.value) {
    chatMessagesRef.value.scrollTop = chatMessagesRef.value.scrollHeight;
  }
};

const openChat = () => {
  isChatOpen.value = true;
  showQuickReplies.value = true;
  scrollChatToBottom();
  setTimeout(() => {
    if (chatInputRef.value) chatInputRef.value.focus();
  }, 300);
};

const closeChat = () => {
  isChatOpen.value = false;
};

const findResponse = (text) => {
  const lower = text.toLowerCase();
  for (const [key, response] of Object.entries(chatResponses)) {
    if (key !== 'default' && lower.includes(key)) {
      return response;
    }
  }
  return chatResponses['default'];
};

const addMessage = (text, isUser = true) => {
  chatMessages.value.push({ text, isUser });
  scrollChatToBottom();
};

const simulateTyping = (callback) => {
  isTyping.value = true;
  showQuickReplies.value = false;
  scrollChatToBottom();
  const delay = 800 + Math.random() * 700;
  setTimeout(() => {
    isTyping.value = false;
    callback();
    scrollChatToBottom();
    setTimeout(() => {
      showQuickReplies.value = true;
    }, 500);
  }, delay);
};

const sendMessage = () => {
  const text = chatInput.value.trim();
  if (!text || isTyping.value) return;
  chatInput.value = '';
  addMessage(text, true);
  showQuickReplies.value = false;
  simulateTyping(() => {
    const reply = findResponse(text);
    addMessage(reply, false);
  });
};

const sendQuickReply = (reply) => {
  if (isTyping.value) return;
  addMessage(reply.text, true);
  showQuickReplies.value = false;
  simulateTyping(() => {
    const response = findResponse(reply.keyword);
    addMessage(response, false);
  });
};

let scrollHandler = null;
let sectionObservers = [];

const setupNavbarScroll = () => {
  // Scroll blur handler
  scrollHandler = () => {
    isScrolled.value = window.scrollY > 80;
  };
  window.addEventListener('scroll', scrollHandler, { passive: true });
  // Initial check
  scrollHandler();

  // Section intersection observer for active link tracking
  const observer = new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        activeSection.value = entry.target.id;
      }
    });
  }, { threshold: 0.2, rootMargin: '-80px 0px -50% 0px' });

  // Observe each section
  navLinks.forEach((link) => {
    const el = document.getElementById(link.id);
    if (el) {
      observer.observe(el);
      sectionObservers.push({ el, observer });
    }
  });
};

const cleanupNavbarScroll = () => {
  if (scrollHandler) {
    window.removeEventListener('scroll', scrollHandler);
  }
  sectionObservers.forEach(({ el, observer }) => observer.unobserve(el));
  sectionObservers = [];
};

const addToCart = (product) => {
  try {
    cartStore.addItem(product);
    isCartOpen.value = true;
  } catch (error) {
    toast.warning(error.message);
    router.push('/login');
  }
};

const brandOptions = [
  { name: 'Apple', imageUrl: 'https://cdn.simpleicons.org/apple/0f172a' },
  { name: 'Samsung', imageUrl: 'https://cdn.simpleicons.org/samsung/0f172a' },
  { name: 'Google', imageUrl: 'https://cdn.simpleicons.org/google/0f172a' },
  { name: 'OnePlus', imageUrl: 'https://cdn.simpleicons.org/oneplus/0f172a' },
  { name: 'Xiaomi', imageUrl: 'https://cdn.simpleicons.org/xiaomi/0f172a' },
  { name: 'ทั้งหมด', icon: MoreHorizontal }
];

const fetchAvailableProducts = async () => {
  try {
    const response = await axios.get(`${getApiBasePath()}/products`);
    availableProducts.value = response.data.filter(p => p.status === 'available');
  } catch (error) {
    console.error('Error fetching products:', error);
  } finally {
    loading.value = false;
  }
};

const filteredProducts = computed(() => {
  let result = availableProducts.value;
  if (selectedBrand.value) {
    result = result.filter(p => p.brand.toLowerCase() === selectedBrand.value.toLowerCase());
  }
  if (searchQuery.value.trim()) {
    const q = searchQuery.value.trim().toLowerCase();
    result = result.filter(p =>
      (p.model && p.model.toLowerCase().includes(q)) ||
      (p.brand && p.brand.toLowerCase().includes(q)) ||
      (p.storage && p.storage.toLowerCase().includes(q)) ||
      (p.color && p.color.toLowerCase().includes(q))
    );
  }
  return result;
});

const displayedProducts = computed(() => {
  return showAll.value ? filteredProducts.value : filteredProducts.value.slice(0, 8);
});

const getConditionLabel = (health) => {
  if (health >= 95) return 'MINT';
  if (health >= 85) return 'GOOD';
  return 'FAIR';
};

const getConditionClass = (health) => {
  if (health >= 95) return 'border-red-400 text-red-600';
  if (health >= 85) return 'border-slate-300 text-slate-500';
  return 'border-orange-200 text-orange-600';
};

onMounted(fetchAvailableProducts);


const videoPlayer = ref(null)

// ===== Count-up Animation for Trust Indicators =====
const trustCount1 = ref(0);
const trustCount2 = ref(0);
const trustCount3 = ref(0);
const trustObserver = ref(null);
let countUpStarted = false;

const startCountUp = () => {
  if (countUpStarted) return;
  countUpStarted = true;

  const targets = [500, 98, 30];
  const durations = [2000, 1500, 1200]; // ms
  const startTime = performance.now();

  const animate = (currentTime) => {
    const elapsed = currentTime - startTime;

    trustCount1.value = Math.min(Math.floor((elapsed / durations[0]) * targets[0]), targets[0]);
    trustCount2.value = Math.min(Math.floor((elapsed / durations[1]) * targets[1]), targets[1]);
    trustCount3.value = Math.min(Math.floor((elapsed / durations[2]) * targets[2]), targets[2]);

    if (elapsed < Math.max(...durations)) {
      requestAnimationFrame(animate);
    }
  };

  requestAnimationFrame(animate);
};

const typedText = ref('');
const fullText = 'ทุกเครื่องผ่านการตรวจสอบ อย่างละเอียดถี่ถ้วน โดยผู้เชี่ยวชาญ.';

const startTyping = () => {
  let i = 0;
  const timer = setInterval(() => {
    typedText.value += fullText[i];
    i++;
    if (i === fullText.length) clearInterval(timer);
  }, 50); // เปลี่ยนจาก 100 เป็น 50ms
};

const vIntersection = {
  mounted(el) {
    const observer = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          el.classList.add('visible');
          if (el.querySelector('.typing-text')) startTyping();
          observer.unobserve(el);
        }
      });
    }, { threshold: 0.1 });
    observer.observe(el);
  }
};

onMounted(() => {
  if (videoPlayer.value) {
    // บังคับให้ Muted อีกรอบเพื่อความชัวร์
    videoPlayer.value.muted = true
    // สั่งให้เล่น
    videoPlayer.value.play().catch(error => {
      console.error("Video play failed:", error)
    })
  }

  // Navbar scroll and section tracking
  setupNavbarScroll();

  // IntersectionObserver for Trust Indicators count-up
  if (trustObserver.value) {
    const observer = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          startCountUp();
          observer.unobserve(entry.target);
        }
      });
    }, { threshold: 0.5 });
    observer.observe(trustObserver.value);
  }
})

onUnmounted(() => {
  cleanupNavbarScroll();
})
</script>

<style scoped>
.font-sans {
  font-family: 'Tahoma', 'Sarabun', sans-serif;
}

@keyframes fade-in {
  from { opacity: 0; }
  to { opacity: 1; }
}

@keyframes fade-in-up {
  from {
    opacity: 0;
    transform: translateY(20px);
  }

  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.animate-fade-in {
  animation: fade-in 1s ease-out forwards;
}

.animate-fade-in-up {
  animation: fade-in-up 0.8s cubic-bezier(0.2, 0, 0, 1) forwards;
}

.delay-100 {
  animation-delay: 0.1s;
}

.delay-200 {
  animation-delay: 0.2s;
}

/* Hover reveal animation */
.hover-reveal {
  transition: transform 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
}

.hover-reveal:hover {
  transform: translateY(-5px);
}

@keyframes blink {
  50% { opacity: 0; }
}

.cursor {
  animation: blink 1s step-end infinite;
  color: #2563EB;
}

/* ===== New Premium Animations ===== */

/* Floating element animations */
.floating-element {
  animation: float 6s ease-in-out infinite;
}

.floating-element-delayed {
  animation: float-alt 8s ease-in-out 2s infinite;
}

.floating-element-slow {
  animation: float 10s ease-in-out 4s infinite;
}

@keyframes float {
  0%, 100% {
    transform: translateY(0px) rotate(12deg);
  }
  50% {
    transform: translateY(-20px) rotate(17deg);
  }
}

@keyframes float-alt {
  0%, 100% {
    transform: translateY(0px) rotate(-12deg);
  }
  50% {
    transform: translateY(-20px) rotate(-7deg);
  }
}

@keyframes float-delayed {
  0%, 100% {
    transform: translateY(0px);
  }
  50% {
    transform: translateY(-15px);
  }
}

/* Pulse animations for orbs */
@keyframes pulse-slow {
  0%, 100% {
    opacity: 0.2;
    transform: scale(1);
  }
  50% {
    opacity: 0.3;
    transform: scale(1.05);
  }
}

.animate-pulse-slow {
  animation: pulse-slow 6s ease-in-out infinite;
}

.animate-pulse-slow-delayed {
  animation: pulse-slow 8s ease-in-out 3s infinite;
}

.animate-pulse-very-slow {
  animation: pulse-slow 10s ease-in-out 1s infinite;
}

/* Scroll indicator */
@keyframes scroll-dot {
  0%, 100% {
    transform: translateY(0);
    opacity: 1;
  }
  50% {
    transform: translateY(6px);
    opacity: 0.3;
  }
}

.animate-scroll-dot {
  animation: scroll-dot 1.5s ease-in-out infinite;
}

@keyframes bounce-slow {
  0%, 100% {
    transform: translateX(-50%) translateY(0);
  }
  50% {
    transform: translateX(-50%) translateY(8px);
  }
}

.animate-bounce-slow {
  animation: bounce-slow 2.5s ease-in-out infinite;
}

/* Cart badge pop animation */
@keyframes cart-badge-pop {
  0% {
    transform: scale(0);
  }
  50% {
    transform: scale(1.3);
  }
  100% {
    transform: scale(1);
  }
}

.animate-cart-badge {
  animation: cart-badge-pop 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
}

/* Accordion expand/collapse animation */
.accordion-collapse {
  display: grid;
  grid-template-rows: 0fr;
  min-height: 0;
  transition: grid-template-rows 0.35s cubic-bezier(0.25, 0.46, 0.45, 0.94);
}

.accordion-collapse > div {
  overflow: hidden;
}

.accordion-collapse.accordion-open {
  grid-template-rows: 1fr;
}

/* FAQ scroll-reveal animation */
.faq-header,
.faq-item,
.faq-cta {
  opacity: 0;
  transform: translateY(24px);
  transition: all 0.7s cubic-bezier(0.2, 0, 0, 1);
}

.section-animate.visible .faq-header {
  opacity: 1;
  transform: translateY(0);
  transition-delay: 0.05s;
}

.section-animate.visible .faq-item:nth-child(1) {
  opacity: 1;
  transform: translateY(0);
  transition-delay: 0.12s;
}

.section-animate.visible .faq-item:nth-child(2) {
  opacity: 1;
  transform: translateY(0);
  transition-delay: 0.22s;
}

.section-animate.visible .faq-item:nth-child(3) {
  opacity: 1;
  transform: translateY(0);
  transition-delay: 0.32s;
}

.section-animate.visible .faq-item:nth-child(4) {
  opacity: 1;
  transform: translateY(0);
  transition-delay: 0.42s;
}

.section-animate.visible .faq-item:nth-child(5) {
  opacity: 1;
  transform: translateY(0);
  transition-delay: 0.52s;
}

.section-animate.visible .faq-cta {
  opacity: 1;
  transform: translateY(0);
  transition-delay: 0.62s;
}

/* Add these to existing animation delays */
.delay-300 {
  animation-delay: 0.3s;
}

.delay-400 {
  animation-delay: 0.4s;
}

.delay-500 {
  animation-delay: 0.5s;
}

.delay-600 {
  animation-delay: 0.6s;
}

.delay-700 {
  animation-delay: 0.7s;
}

/* Chatbot Widget Styles */
.chat-window {
  box-shadow: 0 25px 60px rgba(0, 0, 0, 0.15);
  animation: chat-slide-up 0.35s cubic-bezier(0.34, 1.56, 0.64, 1);
}

@keyframes chat-slide-up {
  from {
    opacity: 0;
    transform: translateY(20px) scale(0.95);
  }
  to {
    opacity: 1;
    transform: translateY(0) scale(1);
  }
}

/* Mobile: slide up from bottom with no scale */
@media (max-width: 639px) {
  .chat-window {
    animation: chat-slide-up-mobile 0.3s cubic-bezier(0.2, 0, 0, 1);
  }
  
  @keyframes chat-slide-up-mobile {
    from {
      opacity: 0;
      transform: translateY(30px);
    }
    to {
      opacity: 1;
      transform: translateY(0);
    }
  }
}

@keyframes typing-bounce {
  0%, 80%, 100% {
    transform: translateY(0);
  }
  40% {
    transform: translateY(-6px);
  }
}

.typing-dots span {
  animation: typing-bounce 1.2s ease-in-out infinite;
}

.typing-dots span:nth-child(2) {
  animation-delay: 0.15s;
}

.typing-dots span:nth-child(3) {
  animation-delay: 0.3s;
}

/* Chat scrollbar */
.chat-window .overflow-y-auto::-webkit-scrollbar {
  width: 4px;
}

.chat-window .overflow-y-auto::-webkit-scrollbar-track {
  background: transparent;
}

.chat-window .overflow-y-auto::-webkit-scrollbar-thumb {
  background: #CBD5E1;
  border-radius: 99px;
}

.chat-window .overflow-y-auto::-webkit-scrollbar-thumb:hover {
  background: #94A3B8;
}

/* Mobile: full viewport height + safe area padding */
@media (max-width: 639px) {
  .chat-window {
    height: 100dvh;
  }
  
  .chat-window .overflow-y-auto {
    padding-bottom: env(safe-area-inset-bottom, 0px);
  }
}
</style>
