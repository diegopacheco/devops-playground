from tf2 import Tf2, LocalCommandExecutor

tf2 = Tf2()

@tf2.test("resources.docker_container.nginx")
def test_nginx_status(self):
    executor = LocalCommandExecutor()
    executor.execute(
        f"docker container inspect { self.values.name } -f '{{{{ .State.Status }}}}'"
    )
    assert executor.result.stdout.strip() == "running"

@tf2.test("resources.docker_container.nginx")
def test_nginx_public_access(self):
    executor = LocalCommandExecutor()
    executor.execute(
        f"curl -s { tf2.outputs.nginx_address.value }"
    )
    assert executor.result.rc == 0

tf2.run()