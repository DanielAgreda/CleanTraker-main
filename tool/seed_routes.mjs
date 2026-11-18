// Carga las 3 direcciones de rutas de camiones en Firestore (colección `routes`).
// Uso (desde la carpeta tool/):
//   npm install firebase-admin
//   $env:GOOGLE_APPLICATION_CREDENTIALS="C:\ruta\serviceAccount.json"
//   node seed_routes.mjs
// Edita `routes` con las direcciones reales antes de ejecutarlo.
import { initializeApp, applicationDefault } from 'firebase-admin/app';
import { getFirestore } from 'firebase-admin/firestore';

const routes = [
  {
    id: 'route_1',
    order: 1,
    street: 'Carrera 15 # 85-32',
    zone: 'Chapinero, Bogotá',
    distanceKm: '2,4 km',
    estimatedMinutes: 12,
    scheduleInfo: 'Martes, Jueves y Sábado • 8:00 PM',
  },
  {
    id: 'route_2',
    order: 2,
    street: 'Calle 72 # 10-34',
    zone: 'Quinta Camacho, Bogotá',
    distanceKm: '1,5 km',
    estimatedMinutes: 8,
    scheduleInfo: 'Lunes, Miércoles y Viernes • 7:30 PM',
  },
  {
    id: 'route_3',
    order: 3,
    street: 'Avenida Suba # 115-20',
    zone: 'Suba, Bogotá',
    distanceKm: '4,2 km',
    estimatedMinutes: 22,
    scheduleInfo: 'Lunes, Miércoles y Viernes • 9:00 PM',
  },
];

initializeApp({ credential: applicationDefault() });
const db = getFirestore();

for (const { id, ...data } of routes) {
  await db.collection('routes').doc(id).set(data);
  console.log(`routes/${id} guardado`);
}
