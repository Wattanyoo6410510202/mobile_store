import { createRouter, createWebHistory } from 'vue-router';
import { useAuthStore } from '../store/auth';

const routes = [
  {
    path: '/',
    name: 'LandingPage',
    component: () => import('../views/LandingPage.vue'),
  },
  {
    path: '/login',
    name: 'Login',
    component: () => import('../views/Login.vue'),
    meta: { guest: true },
  },
  {
    path: '/admin',
    component: () => import('../layouts/DefaultLayout.vue'),
    children: [
      {
        path: '',
        name: 'Dashboard',
        component: () => import('../views/Dashboard.vue'),
      },
      {
        path: 'products',
        name: 'ProductList',
        component: () => import('../views/products/ProductList.vue'),
      },
      {
        path: 'products/add',
        name: 'AddProduct',
        component: () => import('../views/products/AddProduct.vue'),
      },
      {
        path: 'products/edit/:id',
        name: 'EditProduct',
        component: () => import('../views/products/AddProduct.vue'),
      },
      {
        path: 'products/scan',
        name: 'Scanner',
        component: () => import('../views/products/Scanner.vue'),
      },
    ],
    meta: { requiresAuth: true },
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

router.beforeEach((to, from, next) => {
  const authStore = useAuthStore();
  if (to.meta.requiresAuth && !authStore.isAuthenticated) {
    next('/login');
  } else if (to.meta.guest && authStore.isAuthenticated) {
    next('/');
  } else {
    next();
  }
});

export default router;
