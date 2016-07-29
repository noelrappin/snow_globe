class CheckoutForm {

  // # START: checkout_form_format
  format() {
    this.numberField().payment("formatCardNumber")
    this.expiryField().payment("formatCardExpiry")
    this.cvcField().payment("formatCardCVC")
    this.disableButton()
  }
  // # END: checkout_form_format

  // # START: checkout_form_valid_fields
  form() { return $("#payment-form") }

  validFields() { return this.form().find(".valid-field") }

  numberField() { return this.form().find("#credit_card_number") }

  expiryField() { return this.form().find("#expiration_date") }

  cvcField() { return this.form().find("#cvc") }
  // # END: checkout_form_valid_fields

  // # START: checkout_form_display_status
  displayStatus() {
    this.displayFieldStatus(this.numberField(), this.isNumberValid())
    this.displayFieldStatus(this.expiryField(), this.isExpiryValid())
    this.displayFieldStatus(this.cvcField(), this.isCvcValid())
    this.cardImage().attr("src", this.imageUrl())
    this.buttonStatus()
  }

  displayFieldStatus(field, valid) {
    const parent = field.parents(".form-group")
    if (field.val() === "") {
      parent.removeClass("has-error")
      parent.removeClass("has-success")
    }
    parent.toggleClass("has-error", !valid)
    parent.toggleClass("has-success", valid)
  }


  isNumberValid() {
    return $.payment.validateCardNumber(this.numberField().val())
  }

  isExpiryValid() {
    const date = $.payment.cardExpiryVal(this.expiryField().val())
    return $.payment.validateCardExpiry(date.month, date.year)
  }

  isCvcValid() { return $.payment.validateCardCVC(this.cvcField().val()) }

  cardImage() { return $("#card-image") }

  imageUrl() { return `/assets/creditcards/${this.cardType()}.png` }

  cardType() { return $.payment.cardType(this.numberField().val()) || "credit" }

  buttonStatus() {
    return this.valid() ? this.enableButton() : this.disableButton()
  }

  valid() {
    return this.isNumberValid() && this.isExpiryValid() && this.isCvcValid()
  }

  button() { return this.form().find(".btn") }

  disableButton() { this.button().toggleClass("disabled", true) }

  enableButton() { this.button().toggleClass("disabled", false) }

  isEnabled() { return !this.button().hasClass("disabled") }

  isButtonDisabled() { return this.button().prop("disabled") }
  // # END: checkout_form_display_status


  // # START: checkout_form
  paymentTypeRadio() { return $(".payment-type-radio") }

  selectedPaymentType() { return $("input[name=payment_type]:checked").val() }

  creditCardForm() { return $("#credit-card-info") }

  isPayPal() { return this.selectedPaymentType() === "paypal" }

  setCreditCardVisibility() {
    this.creditCardForm().toggleClass("hidden", this.isPayPal())
  }
  // # END: checkout_form

  submit() { this.form().get(0).submit() }

  appendHidden(name, value) {
    const field = $("<input>")
      .attr("type", "hidden")
      .attr("name", name)
      .val(value)
    this.form().append(field)
  }
}

// # START: token_handler
class TokenHandler {
  static handle(status, response) {
    new TokenHandler(status, response).handle()
  }

  constructor(status, response) {
    this.checkoutForm = new CheckoutForm()
    this.status = status
    this.response = response
  }

  isError() { return this.response.error }

  handle() {
    if (this.isError()) {
      this.checkoutForm.appendError(this.response.error.message)
      this.checkoutForm.enableButton()
    } else {
      this.checkoutForm.appendHidden("stripe_token", this.response.id)
      this.checkoutForm.submit()
    }
  }
}
// # END: token_handler

// # START: payment_form_handler
class PaymentFormHandler {

  // # START: stripe_form_constructor
  constructor() {
    this.checkoutForm = new CheckoutForm()
    this.checkoutForm.format()
    this.initEventHandlers()
    this.initPaymentTypeHandler()
  }
  // # END: stripe_form_constructor

  // # START: stripe_form_event_handlers
  initEventHandlers() {
    this.checkoutForm.form().submit(event => {
      if (!this.checkoutForm.isPayPal()) {
        this.handleSubmit(event)
      }
    })
    this.checkoutForm.validFields().keyup(() => {
      this.checkoutForm.displayStatus()
    })
  }

  initPaymentTypeHandler() {
    this.checkoutForm.paymentTypeRadio().click(() => {
      this.checkoutForm.setCreditCardVisibility()
    })
  }
  // # END: stripe_form_event_handlers

  handleSubmit(event) {
    event.preventDefault()
    if (this.checkoutForm.isButtonDisabled()) {
      return false
    }
    this.checkoutForm.disableButton()
    Stripe.card.createToken(this.checkoutForm.form(), TokenHandler.handle)
    return false
  }
}

$(() => new PaymentFormHandler())
// # END: payment_form_handler
