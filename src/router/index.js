import { createRouter, createWebHistory } from 'vue-router';
import Home from '@/pages/Home.vue';
import About from '@/pages/About.vue';
import BaekjoonKing from '@/pages/BaekjoonKing.vue';
import BaekjoonKingWait from '@/pages/BaekjoonKingWaiting.vue';
import Notice from '@/pages/Notice.vue';
import Oms from '@/pages/oms.vue';
import ZeroPage from '@/pages/ZeroPage.vue';
import Clug from '@/pages/Clug.vue';
import Sign from '@/pages/SignEvent.vue';
import Ranking from '@/pages/Ranking.vue';
import CurrentRanking from '@/pages/CurrentRanking.vue';
import Study from '@/pages/Study.vue';
import Omss from '@/pages/omss.vue';
import OmsDetail from '@/pages/omsDetail.vue';

const routes = [
    { path: '/', component: Home },
    { path: '/about', component: About },
    { path: '/zeropage', component: ZeroPage },
    { path: '/clug', component: Clug },
    { path: '/baekjoonking', component: BaekjoonKing },
    { path: '/notice', component: Notice },
    { path: '/oms_week', component: Oms },
    { path: '/sign', component: Sign },
    { path: '/rank', component: Ranking},
    { path: '/current-rank', component:CurrentRanking},
    { path: '/study', component:Study},
    { path: '/baekjoonking-wait', component:BaekjoonKingWait},
    { path: '/omss', component:Omss},
    { path: '/oms/:id', component:OmsDetail}
];

const router = createRouter({
    history: createWebHistory(),
    routes,
});

export default router;
