class RspecFormatter < RSpec::Core::Formatters::ProgressFormatter
  def example_failed(notification)
    exception_presenter = RSpec::Core::Formatters::ExceptionPresenter.new(
      notification.exception,
      notification.example
    )

    message = "\n"
    message += "💥 "
    message += exception_presenter.message_lines.join("\n")
    message += "\n"
    message += "Location: #{notification.example.location}\n\n"

    @output.print(RSpec::Core::Formatters::ConsoleCodes.wrap(message, :failure))
  end

  def dump_pending(notification)
    # noop
  end
end

