import spock.lang.Specification
import com.dsl.PipelineSteps

class PipelineSpec extends Specification {

    def "should execute a shell command"() {
        given:
        def mockSteps = Mock(PipelineSteps)
        def myLogic = new com.dsl.Pipeline(mockSteps)

        when:
        myLogic.runCommand(mockSteps)

        then:
        1 * mockSteps.sh('echo "Hello"')
    }

    def "should execute build"() {
        given:
        def mockSteps = Mock(PipelineSteps)
        def myLogic = new com.dsl.Pipeline(mockSteps)

        when:
        myLogic.build()

        then:
        1 * mockSteps.sh('echo "Building application"')
    }

    def "should execute test"() {
        given:
        def mockSteps = Mock(PipelineSteps)
        def myLogic = new com.dsl.Pipeline(mockSteps)

        when:
        myLogic.test()

        then:
        1 * mockSteps.sh('echo "Running tests"')
    }
}