from tf2 import Tf2, Terraform, TerraformPlanLoader

tf2 = Tf2(Terraform(TerraformPlanLoader()))

@tf2.test("resources.kubernetes_deployment.nginx_deployment")
def test_nginx_namespace_not_default(self):
    assert self.values.metadata[0].namespace != "default"

@tf2.test("resources.kubernetes_deployment.nginx_deployment")
def test_nginx_label_env(self):
    assert (self.values.metadata[0].labels.app_kubernetes_io_env in ["production", "development"]) is True
    assert (self.values.spec[0].template[0].metadata[0].labels.app_kubernetes_io_env in ["production", "development"]) is True

@tf2.test("resources.kubernetes_deployment.nginx_deployment", ignore_errors=True)
def test_nginx_min_replicas(self):
    assert int(self.values.spec[0].replicas) >= 2

@tf2.test("resources.kubernetes_deployment.nginx_deployment")
def test_nginx_image_not_latest(self):
    assert self.values.spec[0].template[0].spec[0].container[0].image.count(":") == 1
    assert self.values.spec[0].template[0].spec[0].container[0].image.endswith(":latest") is False

tf2.run()