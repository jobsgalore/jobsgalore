class ExperimentController < ApplicationController

  def create
    @experiment = Experiment.create(experiment_params)
    head :ok
  end

  private

  def experiment_params
    params.require(:experiment).permit(:name, :variant, params: {})
  end

end