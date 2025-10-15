const { App, Chart } = require('cdk8s');
const { Deployment, Service, ServiceType } = require('cdk8s-plus-27');

class NginxChart extends Chart {
  constructor(scope, id) {
    super(scope, id);

    const deployment = new Deployment(this, 'nginx-deployment', {
      replicas: 2,
      containers: [
        {
          name: 'nginx',
          image: 'nginx:latest',
          port: 80,
        }
      ],
    });

    deployment.exposeViaService({
      name: 'nginx-service',
      serviceType: ServiceType.NODE_PORT,
      ports: [{ port: 80, nodePort: 30080 }],
    });
  }
}

const app = new App({ outdir: 'dist' });
new NginxChart(app, 'nginx');

app.synth();
console.log('Kubernetes manifests generated in dist/ directory');
