class Loader extends React.Component{
    constructor(props){
        super(props);
        this.state = {jobs:[]};
        this.componentDidMount = this.componentDidMount.bind(this);
    }

    componentDidMount(){
        $.ajax({
            type: "get",
            url: this.props.url_similar_for_job,
            success: function (data) {
               this.setState({jobs: data});
            }.bind(this),
            dataType: 'json'
        });
    }

    render() {
        const {size} = this.props;
        let jobs = this.state.jobs.map((job)=> <JobMd key={job.id} job={job} /> );
        return (
       <div>
            <h3>Similar vacancies</h3>
           {jobs}
       </div>
        );
    }
}
