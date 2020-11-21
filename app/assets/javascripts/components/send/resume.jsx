class Resume extends React.Component{
    constructor(props){
        super(props);
        this.state={visible:false,
                    checked:false};
        this.handleClickItem =  this.handleClickItem.bind(this);
        this.handleOnClickResume =  this.handleOnClickResume.bind(this);
    }

    handleClickItem(){
        this.state.visible ? this.setState({visible:false}) : this.setState({visible:true})
    }

    handleOnClickResume(){
        this.props.onchange('resume_'+this.props.keyResume);
    }

    render(){
        let styleResume;
        (this.props.keyResume % 2 == 0) ? styleResume = "panel panel-success" :  styleResume = "panel panel-warning";
        let description;
        if (this.state.visible){
            description = <div className="panel-body">
                            <p>
                                <span><strong>Location:&nbsp;</strong></span>
                                <span className="text-warning">{this.props.resume.location}</span>
                            </p>
                            <p>
                                <span><strong>Industry:&nbsp;</strong></span>
                                <span className="text-warning">{this.props.resume.industry}</span>
                            </p>
                            <p>
                                <span><strong>Desired salary:&nbsp;</strong></span>
                                <span className="text-warning">{"$"+this.props.resume.salary}</span>
                            </p>
                            <p dangerouslySetInnerHTML={{__html: this.props.resume.description}} />
                          </div>
        } else{
            description = null;
        }
        return(
                <div className={styleResume} key={this.props.keyResume} onClick={this.handleOnClickResume}>
                    <div className="panel-heading">
                        <input type="radio" id={"contactChoice"+this.props.keyResume} checked={this.props.check} name={this.props.name} value={this.props.resume.id} />
                        <span>&nbsp;{this.props.resume.title}</span>
                        <span style={{float: "right"}}> <a  onClick={this.handleClickItem}>Show</a></span>
                    </div>
                    {description}
                </div>
        );
    }
}