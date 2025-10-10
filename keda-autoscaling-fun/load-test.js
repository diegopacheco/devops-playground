import http from 'k6/http';

export const options = {
  vus: 280,
  duration: '23s',
};

export default function () {
  http.get('http://rust-webservice.default.svc.cluster.local:8080/stress');
}
