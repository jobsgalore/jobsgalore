class InputMask extends React.Component{
    constructor(props) {
        super(props);
        var a = function (dataformat, value) {
            if (value !== undefined) {
                var fNumber, iFormat, iNumber, last;
                fNumber = '';
                value = String(value).replace(/\D/g, '');
                for (iFormat = 0, iNumber = 0; iFormat < dataformat.length; iFormat = iFormat + 1) {
                    if (/\d/g.test(dataformat.charAt(iFormat))) {
                        if (dataformat.charAt(iFormat) === value.charAt(iNumber)) {
                            fNumber += value.charAt(iNumber);
                            iNumber = iNumber + 1;
                        } else {
                            fNumber += dataformat.charAt(iFormat);
                        }
                    } else if (dataformat.charAt(iFormat) !== 'd') {
                        if (value.charAt(iNumber) !== '' || dataformat.charAt(iFormat) === '+') {
                            fNumber += dataformat.charAt(iFormat);
                        }
                    } else {
                        if (value.charAt(iNumber) === '') {
                            fNumber += '';
                        } else {
                            fNumber += value.charAt(iNumber);
                            iNumber = iNumber + 1;
                        }
                    }
                }
                last = dataformat.charAt(fNumber.length);
                if (last !== 'd') {
                    fNumber += last;
                }

                return fNumber;
            }
        };
        this.handleInput = this.handleInput.bind(this);
        this.state = {  id:this.props.id,
                        numberphone: a,
                        name: this.props.name,
                        class_name: this.props.class_name,
                        dataformat: this.props.dataformat,
                        value: a(this.props.dataformat, this.props.value),
                        placeholder: this.props.placeholder};
    }

    handleInput(){
        this.setState({value: this.state.numberphone(this.state.dataformat, document.querySelector('#' + this.state.id).value)});
    };

    render(){
       return(
           <input style={this.props.style} ref={this.props.inputRef} autoComplete={this.state.autocomplete} id={this.state.id} onInput={this.handleInput} className={this.state.class_name} name={this.state.name} value={this.state.value} placeholder={this.state.placeholder} defaultValue={this.props.defaultValue} ></input>
       );
    }
}