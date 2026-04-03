class TreeSpacingsController < ApplicationController
  def show
    @opening_width = params[:opening_width].to_f if params[:opening_width].present?
    @frame_count = params[:frame_count].to_i if params[:frame_count].present?
    @frame_thickness = params[:frame_thickness].to_f if params[:frame_thickness].present?
    @result = spacing_result if params[:opening_width].present? || params[:frame_count].present? || params[:frame_thickness].present?
  end

  private

  def spacing_result
    return { error: "Iki uzunluk arasindaki toplam olcu 0'dan buyuk olmali." } unless @opening_width&.positive?
    return { error: "Basta ve sonda frame olacagi icin frame sayisi en az 2 olmali." } unless @frame_count && @frame_count >= 2
    return { error: "Frame kalinligi 0'dan buyuk olmali." } unless @frame_thickness&.positive?

    total_frame_thickness = @frame_count * @frame_thickness
    return { error: "Frame kalinliklari toplam olcuyu asmamali." } if total_frame_thickness >= @opening_width

    gap_count = @frame_count - 1
    clear_spacing = (@opening_width - total_frame_thickness) / gap_count

    {
      total_frame_thickness: total_frame_thickness,
      gap_count: gap_count,
      clear_spacing: clear_spacing
    }
  end
end
