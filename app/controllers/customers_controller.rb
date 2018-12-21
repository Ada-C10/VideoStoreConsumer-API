class CustomersController < ApplicationController
  SORT_FIELDS = %w(name registered_at postal_code)

  before_action :parse_query_args

  def index
    if @sort
      data = Customer.all.order(@sort)
    else
      data = Customer.all
    end

    data = data.paginate(page: params[:p], per_page: params[:n])

    render json: data.as_json(
      only: [:id, :name, :registered_at, :address, :city, :state, :postal_code, :phone, :account_credit],
      methods: [:movies_checked_out_count]
    )
  end


  def create

    customer = Customer.new(customer_params)

    if customer.save
      render(
        status: :ok, json: customer.as_json( only: [:name, :id] )
      )
    else
      #errors
      render(
        status: :bad_request, json: {errors: {customer: customer.errors.messages }}
      )
    end
  end

  private

    def customer_params
      params.permit(:name, :registered_at, :address, :city, :state, :postal_code, :phone, :account_credit)
    end

  def parse_query_args
    errors = {}
    @sort = params[:sort]
    if @sort and not SORT_FIELDS.include? @sort
      errors[:sort] = ["Invalid sort field '#{@sort}'"]
    end

    unless errors.empty?
      render status: :bad_request, json: { errors: errors }
    end
  end
end
